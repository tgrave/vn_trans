class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.belongs_to :fragment, foreign_key: true
      t.string :content
      t.string :content_translated
      t.integer :updated_by

      t.timestamps
    end
  end
end
