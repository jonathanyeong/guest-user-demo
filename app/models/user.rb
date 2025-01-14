require "securerandom"

class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  enum :provider_type, anonymous: "anonymous"

  def errors
    super.tap { |errors| errors.delete(:password, :blank) if self.anonymous? }
  end

  def self.create_anonymous!
    create!(
      uid: SecureRandom.uuid,
      provider_type: "anonymous"
    )
  end
end
