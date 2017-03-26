class CreateContextWords < ActiveRecord::Migration[5.0]
  def change
    create_table :context_words do |t|
      t.string :name
      t.integer :context_category_id

      t.timestamps
    end
  end
end
