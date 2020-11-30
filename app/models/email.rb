class Email < ApplicationRecord
  belongs_to :mailbox
  validates :template_id, presence: true
  validates :rendered_html, presence: true
  validates :email_payload, presence: true
  validates :template_payload, presence: true


  def from
    fields = email_payload['from']
    "#{fields['name']} <#{fields['email']}>"
  end

  def to
    personalization['to'].map do |fields|
      "#{fields['name']} <#{fields['email']}>"
    end.join(", ")
  end

  def subject
    personalization['subject']
  end

  def personalization
    email_payload['personalizations'].first
  end

  def link_to_template
    "https://mc.sendgrid.com/dynamic-templates/#{template_id}/version/#{template_version}/editor"
  end

  def template_name
    template_payload['name']
  end

  def template_version
    template_payload['versions'].last['id']
  end
end
