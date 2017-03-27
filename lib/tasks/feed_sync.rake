namespace :feed_sync do
  task feeds: [:environment] do
    Feed.all.each do |feed|
      content = Feedjira::Feed.fetch_and_parse feed.url
      content.entries.each do |entry|
        local_entry = feed.entries.where(title: entry.title).first_or_initialize
        local_entry.update_attributes(content: entry.content, author: entry.author, url: entry.url, published: entry.published)
        p "Synced Entry - #{entry.title}"
      end
      p "Synced Feed - #{feed.name}"
    end
    Phrase.destroy_all
    
    generate_three_word_phrases
    generate_two_word_phrases
    generate_one_word_phrases
  end

  def generate_three_word_phrases
    phrase_hash = Hash.new

    Entry.last_day.each do |entry|
      title_words = entry.title.split

      title_words.each_with_index do |word, index|
        next_word_index = index + 1
        two_word_index = index + 2

        next if two_word_index >= title_words.length

        word = clean_word(word)
        next_word = clean_word(title_words[next_word_index])
        two_word = clean_word(title_words[two_word_index])
        next if is_common_word?(word) && is_common_word?(next_word) && is_common_word?(two_word)

        phrase_content = "#{word} #{next_word} #{two_word}"

        if phrase_hash.has_key?(phrase_content)
          next if phrase_hash[phrase_content][:sources].include?(entry.id)
          phrase_hash[phrase_content][:count] = phrase_hash[phrase_content][:count] + 1
          phrase_hash[phrase_content][:sources] << entry.id
        else
          phrase_hash[phrase_content] = {count: 1, sources: [entry.id]}
        end
      end
    end

    phrase_hash.delete_if { |phrase, meta| meta[:count] < 5 }
    phrase_hash.each do |phrase, meta|
      meta[:sources].each do |entry_id|
        Phrase.create_or_increment(phrase, entry_id)
      end
    end
  end

  def generate_two_word_phrases
    phrase_hash = Hash.new

    Entry.last_day.each do |entry|
      title_words = entry.title.split

      title_words.each_with_index do |word, index|
        next_word_index = index + 1
        next if next_word_index >= title_words.length

        word = clean_word(word)
        next_word = clean_word(title_words[next_word_index])
        next if is_common_word?(word) && is_common_word?(next_word)

        phrase_content = "#{word} #{next_word}"

        if phrase_hash.has_key?(phrase_content)
          next if phrase_hash[phrase_content][:sources].include?(entry.id)
          phrase_hash[phrase_content][:count] = phrase_hash[phrase_content][:count] + 1
          phrase_hash[phrase_content][:sources] << entry.id
        else
          phrase_hash[phrase_content] = {count: 1, sources: [entry.id]}
        end
      end
    end

    phrase_hash.delete_if { |phrase, meta| meta[:count] < 5 }
    phrase_hash.each do |phrase, meta|
      containing_phrase = Phrase.where("content like ?", "%#{phrase}%").take
      if containing_phrase.present?
        meta[:sources] = meta[:sources] - containing_phrase.phrase_entries.pluck(:entry_id)
      end
      next unless meta[:sources].size > 3
      meta[:sources].each do |entry_id|
        Phrase.create_or_increment(phrase, entry_id)
      end
    end
  end

  def generate_one_word_phrases
    phrase_hash = Hash.new

    Entry.last_day.each do |entry|
      title_words = entry.title.split

      title_words.each do |word|
        word = clean_word(word)
        next if is_integer?(word)
        next if is_common_word?(word)

        if phrase_hash.has_key?(word)
          next if phrase_hash[word][:sources].include?(entry.id)
          phrase_hash[word][:count] = phrase_hash[word][:count] + 1
          phrase_hash[word][:sources] << entry.id
        else
          phrase_hash[word] = {count: 1, sources: [entry.id]}
        end
      end
    end

    phrase_hash.delete_if { |phrase, meta| meta[:count] < 5 }
    phrase_hash.each do |phrase, meta|
      containing_phrase = Phrase.where("content like ?", "%#{phrase}%").take
      if containing_phrase.present?
        meta[:sources] = meta[:sources] - containing_phrase.phrase_entries.pluck(:entry_id)
      end
      next unless meta[:sources].size > 3
      meta[:sources].each do |entry_id|
        Phrase.create_or_increment(phrase, entry_id)
      end
    end
  end
end