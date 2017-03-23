class FeedsController < ApplicationController
  before_action :set_feed, only: [:show, :edit, :update, :destroy]

  COMMON_WORDS = ["a", "able", "about", "above", "abst", "accordance", "according", "accordingly", "across", "act", "actually", "added", "adj", "affected", "affecting", "affects", "after", "afterwards", "again", "against", "ah", "ain't", "all", "allow", "allows", "almost", "alone", "along", "already", "also", "although", "always", "am", "among", "amongst", "an", "and", "announce", "another", "any", "anybody", "anyhow", "anymore", "anyone", "anything", "anyway", "anyways", "anywhere", "apart", "apparently", "appear", "appreciate", "appropriate", "approximately", "are", "area", "areas", "aren", "arent", "aren't", "arise", "around", "as", "a's", "aside", "ask", "asked", "asking", "asks", "associated", "at", "auth", "available", "away", "awfully", "b", "back", "backed", "backing", "backs", "be", "became", "because", "become", "becomes", "becoming", "been", "before", "beforehand", "began", "begin", "beginning", "beginnings", "begins", "behind", "being", "beings", "believe", "below", "beside", "besides", "best", "better", "between", "beyond", "big", "biol", "both", "brief", "briefly", "but", "by", "c", "ca", "came", "can", "cannot", "cant", "can't", "case", "cases", "cause", "causes", "certain", "certainly", "changes", "clear", "clearly", "c'mon", "co", "com", "come", "comes", "concerning", "consequently", "consider", "considering", "contain", "containing", "contains", "corresponding", "could", "couldnt", "couldn't", "course", "c's", "currently", "d", "date", "definitely", "described", "despite", "did", "didn't", "differ", "different", "differently", "do", "does", "doesn't", "doing", "done", "don't", "down", "downed", "downing", "downs", "downwards", "due", "during", "e", "each", "early", "ed", "edu", "effect", "eg", "eight", "eighty", "either", "else", "elsewhere", "end", "ended", "ending", "ends", "enough", "entirely", "especially", "et", "et-al", "etc", "even", "evenly", "ever", "every", "everybody", "everyone", "everything", "everywhere", "ex", "exactly", "example", "except", "f", "face", "faces", "fact", "facts", "far", "felt", "few", "ff", "fifth", "find", "finds", "first", "five", "fix", "followed", "following", "follows", "for", "former", "formerly", "forth", "found", "four", "from", "full", "fully", "further", "furthered", "furthering", "furthermore", "furthers", "g", "gave", "general", "generally", "get", "gets", "getting", "give", "given", "gives", "giving", "go", "goes", "going", "gone", "good", "goods", "got", "gotten", "great", "greater", "greatest", "greetings", "group", "grouped", "grouping", "groups", "h", "had", "hadn't", "happens", "hardly", "has", "hasn't", "have", "haven't", "having", "he", "hed", "he'd", "he'll", "hello", "help", "hence", "her", "here", "hereafter", "hereby", "herein", "heres", "here's", "hereupon", "hers", "herself", "hes", "he's", "hi", "hid", "high", "higher", "highest", "him", "himself", "his", "hither", "home", "hopefully", "how", "howbeit", "however", "how's", "hundred", "i", "id", "i'd", "ie", "if", "ignored", "i'll", "im", "i'm", "immediate", "immediately", "importance", "important", "in", "inasmuch", "inc", "indeed", "index", "indicate", "indicated", "indicates", "information", "inner", "insofar", "instead", "interest", "interested", "interesting", "interests", "into", "invention", "inward", "is", "isn't", "it", "itd", "it'd", "it'll", "its", "it's", "itself", "i've", "j", "just", "k", "keep", "keeps", "kept", "kg", "kind", "km", "knew", "know", "known", "knows", "l", "large", "largely", "last", "lately", "later", "latest", "latter", "latterly", "least", "less", "lest", "let", "lets", "let's", "like", "liked", "likely", "line", "little", "'ll", "long", "longer", "longest", "look", "looking", "looks", "ltd", "m", "made", "mainly", "make", "makes", "making", "man", "many", "may", "maybe", "me", "mean", "means", "meantime", "meanwhile", "member", "members", "men", "merely", "mg", "might", "million", "miss", "ml", "more", "moreover", "most", "mostly", "mr", "mrs", "much", "mug", "must", "mustn't", "my", "myself", "n", "na", "name", "namely", "nay", "nd", "near", "nearly", "necessarily", "necessary", "need", "needed", "needing", "needs", "neither", "never", "nevertheless", "new", "newer", "newest", "next", "nine", "ninety", "no", "nobody", "non", "none", "nonetheless", "noone", "nor", "normally", "nos", "not", "noted", "nothing", "novel", "now", "nowhere", "number", "numbers", "o", "obtain", "obtained", "obviously", "of", "off", "often", "oh", "ok", "okay", "old", "older", "oldest", "omitted", "on", "once", "one", "ones", "only", "onto", "open", "opened", "opening", "opens", "or", "ord", "order", "ordered", "ordering", "orders", "other", "others", "otherwise", "ought", "our", "ours", "ourselves", "out", "outside", "over", "overall", "owing", "own", "p", "page", "pages", "part", "parted", "particular", "particularly", "parting", "parts", "past", "per", "perhaps", "place", "placed", "places", "please", "plus", "point", "pointed", "pointing", "points", "poorly", "possible", "possibly", "potentially", "pp", "predominantly", "present", "presented", "presenting", "presents", "presumably", "previously", "primarily", "probably", "problem", "problems", "promptly", "proud", "provides", "put", "puts", "q", "que", "quickly", "quite", "qv", "r", "ran", "rather", "rd", "re", "readily", "really", "reasonably", "recent", "recently", "ref", "refs", "regarding", "regardless", "regards", "related", "relatively", "research", "respectively", "resulted", "resulting", "results", "right", "room", "rooms", "run", "s", "said", "same", "saw", "say", "saying", "says", "sec", "second", "secondly", "seconds", "section", "see", "seeing", "seem", "seemed", "seeming", "seems", "seen", "sees", "self", "selves", "sensible", "sent", "serious", "seriously", "seven", "several", "shall", "shan't", "she", "shed", "she'd", "she'll", "shes", "she's", "should", "shouldn't", "show", "showed", "showing", "shown", "showns", "shows", "side", "sides", "significant", "significantly", "similar", "similarly", "since", "six", "slightly", "small", "smaller", "smallest", "so", "some", "somebody", "somehow", "someone", "somethan", "something", "sometime", "sometimes", "somewhat", "somewhere", "soon", "sorry", "specifically", "specified", "specify", "specifying", "state", "states", "still", "stop", "strongly", "sub", "substantially", "successfully", "such", "sufficiently", "suggest", "sup", "sure", "t", "take", "taken", "taking", "tell", "tends", "th", "than", "thank", "thanks", "thanx", "that", "that'll", "thats", "that's", "that've", "the", "their", "theirs", "them", "themselves", "then", "thence", "there", "thereafter", "thereby", "thered", "therefore", "therein", "there'll", "thereof", "therere", "theres", "there's", "thereto", "thereupon", "there've", "these", "they", "theyd", "they'd", "they'll", "theyre", "they're", "they've", "thing", "things", "think", "thinks", "third", "this", "thorough", "thoroughly", "those", "thou", "though", "thoughh", "thought", "thoughts", "thousand", "three", "throug", "through", "throughout", "thru", "thus", "til", "tip", "to", "today", "together", "too", "took", "toward", "towards", "tried", "tries", "truly", "try", "trying", "ts", "t's", "turn", "turned", "turning", "turns", "twice", "two", "u", "un", "under", "unfortunately", "unless", "unlike", "unlikely", "until", "unto", "up", "upon", "ups", "us", "use", "used", "useful", "usefully", "usefulness", "uses", "using", "usually", "uucp", "v", "value", "various", "'ve", "very", "via", "viz", "vol", "vols", "vs", "w", "want", "wanted", "wanting", "wants", "was", "wasn't", "way", "ways", "we", "wed", "we'd", "welcome", "well", "we'll", "wells", "went", "were", "we're", "weren't", "we've", "what", "whatever", "what'll", "whats", "what's", "when", "whence", "whenever", "when's", "where", "whereafter", "whereas", "whereby", "wherein", "wheres", "where's", "whereupon", "wherever", "whether", "which", "while", "whim", "whither", "who", "whod", "whoever", "whole", "who'll", "whom", "whomever", "whos", "who's", "whose", "why", "why's", "widely", "will", "willing", "wish", "with", "within", "without", "wonder", "won't", "words", "work", "worked", "working", "works", "world", "would", "wouldn't", "www", "x", "y", "year", "years", "yes", "yet", "you", "youd", "you'd", "you'll", "young", "younger", "youngest", "your", "youre", "you're", "yours", "yourself", "yourselves", "you've", "z", "zero", "day", "people", "time", "-", ":"]

  def index
    @feeds = Feed.all
  end

  def show
  end

  def new
    @feed = Feed.new
  end

  def edit
  end

  def create
    @feed = Feed.new(feed_params)

    respond_to do |format|
      if @feed.save
        format.html { redirect_to @feed, notice: 'Feed was successfully created.' }
        format.json { render :show, status: :created, location: @feed }
      else
        format.html { render :new }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @feed.update(feed_params)
        format.html { redirect_to @feed, notice: 'Feed was successfully updated.' }
        format.json { render :show, status: :ok, location: @feed }
      else
        format.html { render :edit }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @feed.destroy
    respond_to do |format|
      format.html { redirect_to feeds_url, notice: 'Feed was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def word_aggregator
    word_hash = Hash.new
    entry_titles = Entry.pluck(:title)

    Entry.last_day.each do |entry|
      title_words = entry.title.split

      title_words.each do |word|
        word = clean_word(word)
        next if is_integer?(word)
        next if is_common_word?(word)
        if word_hash.has_key?(word)
          next if word_hash[word][:sources].include?(entry.url)
          word_hash[word][:count] = word_hash[word][:count] + 1
          word_hash[word][:sources] << entry.url
        else
          word_hash[word] = {count: 1, sources: [entry.url]}
        end
      end

      title_words.each_with_index do |word, index|
        next_word_index = index + 1
        next if next_word_index >= title_words.length
        next_word = title_words[next_word_index]
        next if is_common_word?(word) || is_common_word?(next_word)
        word = clean_word(word)
        next_word = clean_word(next_word)

        phrase = "#{word} #{next_word}"

        if word_hash.has_key?(phrase)
          next if word_hash[phrase][:sources].include?(entry.url)
          word_hash[phrase][:count] = word_hash[phrase][:count] + 1
          word_hash[phrase][:sources] << entry.url
        else
          word_hash[phrase] = {count: 1, sources: [entry.url]}
        end
      end

    end

    word_hash.delete_if { |word, meta| meta[:count] < 3 }
    word_hash.each do |word, meta|
      next if word.count(' ') == 0
      word.split.each do |single_word|
        next unless word_hash.key?(single_word)
        if word_hash[single_word][:sources].sort == meta[:sources].sort
          word_hash.delete(single_word)
        end 
      end
    end
    @word_frequencies = word_hash.sort_by{|word, meta| meta[:count]}
  end

  private

    def is_common_word?(word)
      COMMON_WORDS.include?(word.downcase) || COMMON_WORDS.include?(word.downcase.singularize)
    end

    def clean_word(word)
      word.chomp(":").chomp(",").chomp("'")
    end

    def is_integer?(word)
      word.to_i.to_s == word
    end

    def set_feed
      @feed = Feed.find(params[:id])
    end

    def feed_params
      params.require(:feed).permit(:name, :url, :description)
    end
end
