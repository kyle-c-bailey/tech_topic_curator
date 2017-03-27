class CreateEntryContexts < ActiveRecord::Migration[5.0]
  def change
    create_table :entry_contexts do |t|
      t.integer :context_category_id
      t.integer :entry_id

      t.timestamps
    end
  end
end
