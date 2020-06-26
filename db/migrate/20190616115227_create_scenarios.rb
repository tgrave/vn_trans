class CreateScenarios < ActiveRecord::Migration[5.2]
  def change
    create_table :scenarios do |t|
      t.string :name
      t.string :filename
      t.integer :lines
      t.integer :translated

      t.timestamps
    end
  end
end
