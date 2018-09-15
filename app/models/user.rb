# frozen_string_literal: true

class User < ApplicationRecord
  before_save { email.downcase! if email.present? }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, :address, :city, :country, :blood_type, presence: true
  validates :phone,
            presence: true,
            uniqueness: true,
            unless: ->(user) { user.email.present? }
  validates :email,
            presence: true,
            length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false },
            unless: ->(user) { user.phone.present? }
  validates :phone,
            format: { with: /\A(\d+)\z/i }
  validates :password,
            presence: true,
            on: :create
  validates :password,
            confirmation: true

  validates :password_confirmation,
            presence: true,
            length: { minimum: 6 },
            if: ->(u) { !u.password.nil? }

  validate :user_is_donor_or_recipient?

  has_secure_password
  belongs_to :blood_type

  private

  def user_is_donor_or_recipient?
    errors.add(:base, 'User can be a donor or a recipient, not both') if donor_or_recipient?
  end

  def donor_or_recipient?
    [is_donor, is_recipient].compact.count(true) > 1
  end
end
