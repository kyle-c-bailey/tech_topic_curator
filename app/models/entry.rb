class Entry < ApplicationRecord
  belongs_to :feed

  scope :last_day, -> { where("created_at > ?", 24.hours.ago) }
end
