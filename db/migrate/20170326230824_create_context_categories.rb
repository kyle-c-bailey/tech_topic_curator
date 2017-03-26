class CreateContextCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :context_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
