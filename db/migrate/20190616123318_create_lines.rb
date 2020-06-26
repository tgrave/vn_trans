class CreateLines < ActiveRecord::Migration[5.2]
  def change
    create_table :lines do |t|
      t.belongs_to :fragment, foreign_key: true
      t.string :who
      t.text :content
      t.string :who_translated
      t.text :content_translated
      t.integer :updated_by

      t.timestamps
    end
  end
end
