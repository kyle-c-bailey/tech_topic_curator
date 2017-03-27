class ContextCategory < ApplicationRecord
  has_many :context_words, dependent: :destroy
  has_many :entry_contexts, dependent: :destroy
  has_many :entries, through: :entry_contexts
  has_many :phrases, through: :entries
end
