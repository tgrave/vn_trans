class AddLocationsCountToScenario < ActiveRecord::Migration[5.2]
  def change
    add_column :scenarios, :locations_count, :integer, default: 0
    add_column :scenarios, :locations_translated, :integer, default: 0
  end
end
