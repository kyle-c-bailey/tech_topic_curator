class Entry < ApplicationRecord
  belongs_to :feed
  has_many :phrase_entries, dependent: :destroy

  scope :last_day, -> { where("created_at > ?", 24.hours.ago) }
end
