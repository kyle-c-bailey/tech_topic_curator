class EntryContext < ApplicationRecord
  belongs_to :entry
  belongs_to :context_category
end
