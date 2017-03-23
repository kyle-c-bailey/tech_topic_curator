class CreatePhraseEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :phrase_entries do |t|
      t.integer :phrase_id
      t.integer :entry_id

      t.timestamps
    end
  end
end
