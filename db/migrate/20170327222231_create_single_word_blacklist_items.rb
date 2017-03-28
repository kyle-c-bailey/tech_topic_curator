class CreateSingleWordBlacklistItems < ActiveRecord::Migration[5.0]
  def change
    create_table :single_word_blacklist_items do |t|
      t.string :phrase

      t.timestamps
    end
  end
end
