class RecipientWaitList < ApplicationRecord
  belongs_to :user
  belongs_to :blood_type
  validates :user, uniqueness: true
end
