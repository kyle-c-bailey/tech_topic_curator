class Phrase < ApplicationRecord
  has_many :phrase_entries, dependent: :destroy
  has_many :entries, through: :phrase_entries

  BLCKLIST = ["Tech", "App", "Deal", "Video", "Game", "Computer", "Business", "Service", "User", "System", "Device", "Live", "Plan", "Report", "Feature", "Program", "Machine", "Company", "Speed", "Phone", "Offer", "Tool", "Internet", "Review", "Source", "Job", "Human", "Top", "File", "Store", "Team", "Power", "Red", "Car", "Firm", "Market", "Pro", "Hardware", "Street", "Online", "Partner", "News", "Set", "Call", "Hard", "Test", "Network", "Smart", "Sharing", "Office", "Ready", "Play", "Week", "Free", "Faster", "Challenge", "Join", "Tease", "Start", "Enterprise", "Sell", "Content", "Friend", "Issue", "Win", "Download", "Bring", "Share", "Consumer", "Customer", "Gaming", "Display", "Web"]

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
    return if BLACKLIST.include?(content.capitalize)
    phrase = Phrase.where(content: content).take
    unless phrase.present?
      phrase = Phrase.create!(content: content)
    end
    PhraseEntry.create!(phrase_id: phrase.id, entry_id: entry_id)
  end
end
