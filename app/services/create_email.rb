class CreateEmail
  class InvalidRequest < StandardError
    attr_reader :request_result
    def initialize(request_result)
      super()
      @request_result = request_result
    end
  end

  class InvalidTemplate < StandardError
  end

  attr_reader :mailbox

  def initialize(mailbox)
    @mailbox = mailbox
  end

  def call(email_payload)
    email = Email.new(mailbox: mailbox, email_payload: email_payload)

    validate_email_payload_against_sendgrid!(email)
    retrieve_template_payload(email)
    render_html(email)
    email.save!
    email
  end

  private

  def validate_email_payload_against_sendgrid!(email)
    sandbox_enabled_email_payload = email.email_payload.merge({
      'mail_settings' => {
        'sandbox_mode' => {
          'enable' => true
        }
      }
    })
    result = sendgrid_client.post('mail/send', sandbox_enabled_email_payload.to_json)
    raise InvalidRequest.new(result) if result.status != 200
  end

  def retrieve_template_payload(email)
    email.template_id = template_id(email)
    result = sendgrid_client.get("templates/#{email.template_id}")
    raise InvalidTemplate if result.status != 200
    email.template_payload = JSON.parse(result.body)
  end

  def render_html(email)
    handlebars = Handlebars::Handlebars.new

    raw_handlebar_template_string = email.template_payload['versions'].last['html_content']
    sanitized_handlebars_template = sanitize_handlebars_template(raw_handlebar_template_string)

    template = handlebars.compile(sanitized_handlebars_template)
    email.rendered_html = template.call(email.email_payload['personalizations'].first['dynamic_template_data'])
  end

  def sendgrid_client
    Faraday.new('https://api.sendgrid.com/v3/', request: { timeout: 5 }) do |connection|
      connection.headers = {
        accept: 'application/json',
        'Content-Type': 'application/json'
      }

      connection.authorization(:Bearer, mailbox.sendgrid_api_token)
    end
  end

  def template_id(email)
    email.email_payload['template_id']
  end

  def sanitize_handlebars_template(handlebar_template_string)
    handlebar_template_string.gsub('{{# if', '{{#if')
  end
end
