# frozen_string_literal: true

module Tokenable
  extend ActiveSupport::Concern

  included do
    before_create :generate_token
  end

  protected

  def generate_token
    self.confirm_token = loop do
      random_token = (SecureRandom.random_number(9e5) + 1e5).to_i
      break random_token unless self.class.exists?(confirm_token: random_token)
    end
  end
end
