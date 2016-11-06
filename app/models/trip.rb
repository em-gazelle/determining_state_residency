class Trip < ActiveRecord::Base
	belongs_to :person
	validates_presence_of :start_date, :end_date, :state
	# require presence of :total_days .... also make model method
	# same as Person's "leap_year?", set total_days_per_trip

	# refactor to total_days_per_trip for clarity
	# rails def x=y??
	def total_days
		
	end

end
