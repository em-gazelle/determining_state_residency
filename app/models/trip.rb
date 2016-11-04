class Trip < ActiveRecord::Base
	belongs_to :person
	validates_presence_of :start_date, :end_date, :state

end
