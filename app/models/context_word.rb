class ContextWord < ApplicationRecord
  belongs_to :context_category
  has_many :entry_contexts, dependent: :destroy
end
