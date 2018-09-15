# frozen_string_literal: true

class BloodType < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  def can_receive_from
    BloodCompatibility.where(receiver: id).map(&:donator)
  end

  def can_donate_to
    BloodCompatibility.where(donator: id).map(&:receiver)
  end
end
