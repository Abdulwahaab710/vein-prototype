# frozen_string_literal: true

class BloodCompatibility < ApplicationRecord
  belongs_to :donator, class_name: 'BloodType', foreign_key: 'donator_id'
  belongs_to :receiver, class_name: 'BloodType', foreign_key: 'receiver_id'
end
