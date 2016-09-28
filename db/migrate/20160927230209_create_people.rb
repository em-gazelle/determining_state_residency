class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :desired_residency_state
      t.boolean :leap_year
      t.integer :year

      t.timestamps null: false
    end
  end
end
