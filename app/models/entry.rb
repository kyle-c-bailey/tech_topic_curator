class Entry < ApplicationRecord
  belongs_to :feed
  has_many :phrase_entries, dependent: :destroy
  has_many :phrases, through: :phrase_entries
  has_many :entry_contexts, dependent: :destroy
  has_many :context_categories, through: :entry_contexts
  after_save :set_context

  validates_uniqueness_of :title

  scope :last_day, -> { where("created_at > ?", 24.hours.ago) }

  def self.most_phrases
    PhraseEntry.all.group(:entry_id).count.to_a.sort_by{ |entry_id, count| count }.reverse!.top(10)
  end

  private

  def set_context
    ContextWord.all.each do |word|
      if self.title.downcase.include?(word.name.downcase)
        EntryContext.where(context_category_id: word.context_category_id, entry_id: self.id).first_or_create
      end
    end
  end
end
