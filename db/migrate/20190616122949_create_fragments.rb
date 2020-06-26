class CreateFragments < ActiveRecord::Migration[5.2]
  def change
    create_table :fragments do |t|
      t.integer :order
      t.binary :orig_data
      t.belongs_to :scenario, foreign_key: true
      t.integer :f_type
      t.integer :size

      t.timestamps
    end
  end
end
