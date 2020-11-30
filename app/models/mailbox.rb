class Mailbox < ApplicationRecord
  validates :name, presence: true

  validates :sendgrid_mock_api_token, presence: true
  validates :sendgrid_mock_api_token, uniqueness: true

  validates :sendgrid_api_token, presence: true

  before_validation :generate_sendgrid_mock_api_token

  private

  def generate_sendgrid_mock_api_token
    return if sendgrid_mock_api_token.present?
    self.sendgrid_mock_api_token = loop do
      token = SecureRandom.uuid
      break token unless self.class.exists?(sendgrid_mock_api_token: token)
    end
  end
end
