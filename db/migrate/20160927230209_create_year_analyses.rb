class CreateYearAnalyses < ActiveRecord::Migration
  def change
    create_table :year_analyses do |t|
      t.string :desired_residency_state
      t.boolean :leap_year
      t.integer :year

      t.timestamps null: false
    end
  end
end
