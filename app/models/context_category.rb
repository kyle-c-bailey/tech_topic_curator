class ContextCategory < ApplicationRecord
  has_many :context_words, dependent: :destroy
end
