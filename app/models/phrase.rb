class Phrase < ApplicationRecord
  has_many :phrase_entries, dependent: :destroy
  has_many :entries, through: :phrase_entries

  SINGLE_PHRASE_BLACKLIST = ["Tech", "App", "Deal", "Video", "Game", "Computer", "Business", "Service", "User", "System", "Device", "Live", "Plan", "Report", "Feature", "Program", "Machine", "Company", "Speed", "Phone", "Offer", "Tool", "Internet", "Review", "Source", "Job", "Human", "Top", "File", "Store", "Team", "Power", "Red", "Car", "Firm", "Market", "Pro", "Hardware", "Street", "Online", "Partner", "News", "Set", "Call", "Hard", "Test", "Network", "Smart", "Sharing", "Office", "Ready", "Play", "Week", "Free", "Faster", "Challenge", "Join", "Tease", "Start", "Enterprise", "Sell", "Content", "Friend", "Issue", "Win", "Download", "Bring", "Share", "Consumer", "Customer", "Gaming", "Display", "Web", "Mit", "Center", "Control", "Benefit", "Air", "White", "Sense", "Finally", "Player", "March", "Stake", "Won't", "Month", "Global", "Scientist", "Survey", "Researcher", "Screen", "Explain", "Single", "Billion", "Demand", "April", "Boost", "Access", "Product", "Switch", "Microsoft’s", "Desktop", "Learn", "Sales", "Life", "Percent", "Performance", "Watch", "Raises", "Include", "Records", "Build", "Card", "Industry", "Uber’s", "Expand", "Chief", "Media", "Search", "Aim", "Expands", "Deliver", "Care", "Event", "Grow", "Lead", "Official", "Major", "Approach", "Roll"]

  def count
    self.phrase_entries.count
  end

  def similar_phrases
    Rails.cache.fetch("similar_phrases/#{self.id}") do
      similar_phrases = []
      Phrase.all.each do |phrase|
        next if phrase.id == self.id
        intersection = self.phrase_entries.pluck(:entry_id) & phrase.phrase_entries.pluck(:entry_id)
        similar_phrases << {example: phrase.example, count: intersection.size} if intersection.size > 3
      end
      similar_phrases
    end
  end

  def category
    Item.where('lower(name) = ?', self.content.downcase).take
  end

  def entry_display_array
    all_entries = self.entries.joins(:context_categories)
    display_array = []
    ContextCategory.all.each do |category|
      entries = all_entries.where("context_categories.id = ?", category.id)
      next unless entries.present? && entries.count > 2
      display_array << {category: category, weight: entries.count/category.priority, entries: entries}
    end
    display_array.sort_by { |hsh| hsh[:weight] }.reverse!
  end

  def self.create_or_increment(content, entry_id, example)
    return if ContextWord.where("lower(name) = ?", content).present?
    return if SINGLE_PHRASE_BLACKLIST.include?(content.capitalize)
    phrase = Phrase.where(content: content).take
    unless phrase.present?
      phrase = Phrase.create!(content: content, example: example)
    end
    PhraseEntry.create!(phrase_id: phrase.id, entry_id: entry_id)
  end
end
