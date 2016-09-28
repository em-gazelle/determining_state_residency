class RenamingAttributes < ActiveRecord::Migration
  def change
  	rename_column :trips, :date_start, :start_date
  	rename_column :trips, :date_end, :end_date
  	rename_column :trips, :location, :state
  end
end
