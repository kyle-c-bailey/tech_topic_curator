class Entry < ApplicationRecord
  belongs_to :feed
  has_many :phrase_entries, dependent: :destroy
  has_many :entry_contexts, dependent: :destroy
  has_many :context_categories, through: :entry_contexts
  after_save :set_context

  scope :last_day, -> { where("created_at > ?", 24.hours.ago) }

  private

  def set_context
    ContextWord.all.each do |word|
      if self.title.downcase.include?(word.name.downcase)
        EntryContext.first_or_create(context_category_id: word.context_category_id, entry_id: self.id)
      end
    end
  end
end
