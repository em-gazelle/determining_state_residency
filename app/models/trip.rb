class Trip < ActiveRecord::Base
	belongs_to :person
	validates_presence_of :start_date, :end_date, :state

	def total_days_per_trip(start_date, end_date)
		end_date-start_date
		# check tax laws.... currently, a trip from 10/1 -> 10/2 counts as only one day.
	end

end
