class ChangeResidency < ActiveRecord::Migration
  def change
  	rename_column :year_analyses, :desired_residency_state, :desired_state_of_residency
  end
end
