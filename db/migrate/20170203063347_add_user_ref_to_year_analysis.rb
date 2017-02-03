class AddUserRefToYearAnalysis < ActiveRecord::Migration
  def change
    add_reference :year_analyses, :user, index: true, foreign_key: true
  end
end
