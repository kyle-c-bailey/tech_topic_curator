class CreatePhrases < ActiveRecord::Migration[5.0]
  def change
    create_table :phrases do |t|
      t.string :content

      t.timestamps
    end
    add_index :phrases, :content
  end
end
