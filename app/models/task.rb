class Task < ApplicationRecord
  belongs_to :user

  scope :unarchived, -> { where(archived_at: nil) }

  validates :title, presence: true
end
