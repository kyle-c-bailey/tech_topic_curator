class Phrase < ApplicationRecord
  has_many :phrase_entries, dependent: :destroy
  has_many :entries, through: :phrase_entries

  BLACKLIST = ["The Download Mar", "WATCH"]

  def count
    self.phrase_entries.count
  end

  def self.create_or_increment(content, entry_id)
    return if BLACKLIST.include?(content)
    phrase = Phrase.where(content: content).take
    unless phrase.present?
      phrase = Phrase.create!(content: content)
    end
    PhraseEntry.create!(phrase_id: phrase.id, entry_id: entry_id)
  end
end
