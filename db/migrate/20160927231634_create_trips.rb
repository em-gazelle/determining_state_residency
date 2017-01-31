class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.date :date_start
      t.date :date_end
      t.integer :total_days
      t.string :location
      t.references :year_analysis, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
