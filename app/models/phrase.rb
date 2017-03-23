class Phrase < ApplicationRecord
  has_many :phrase_entries, dependent: :destroy

  def count
    self.phrase_entries.count
  end

  def self.create_or_increment(content, entry)
    phrase = Phrase.where(content: content).take
    unless phrase.present?
      phrase = Phrase.create!(content: content)
    end
    PhraseEntry.create!(phrase_id: phrase.id, entry_id: entry.id)
  end
end
