class Phrase < ApplicationRecord
  has_many :phrase_entries, dependent: :destroy
  has_many :entries, through: :phrase_entries

  def count
    self.phrase_entries.count
  end

  def similar_phrases
    Rails.cache.fetch("similar_phrases/#{self.id}") do
      similar_phrases = []
      Phrase.all.each do |phrase|
        next if phrase.id == self.id
        intersection = self.phrase_entries.pluck(:entry_id) & phrase.phrase_entries.pluck(:entry_id)
        similar_phrases << {content: phrase.content, count: intersection.size} if intersection.size > 3
      end
      similar_phrases
    end
  end

  def self.create_or_increment(content, entry_id)
    return if ContextWord.where("lower(name) = ?", content).present?
    phrase = Phrase.where(content: content).take
    unless phrase.present?
      phrase = Phrase.create!(content: content)
    end
    PhraseEntry.create!(phrase_id: phrase.id, entry_id: entry_id)
  end
end
