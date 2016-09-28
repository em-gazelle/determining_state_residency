class Person < ActiveRecord::Base
	has_many :trips
	validates :year, numericality: { greater_than: 0 }
	validates_length_of :desired_state_of_residency, is: 2, message: "Please abbreviate your state to 2 letters"


	def leap_year?(year)
		divisible_by_100 = (year%100).zero?

		if divisible_by_100 && (year%400).zero?
			true
		elsif (year%4).zero? && !divisible_by_100
			true
		end
	end
	# Rules for calculating leap years found at: http://www.timeanddate.com/date/leapyear.html




	# def state_of_residence(total_days_per_state, leap_year?)
	# 	# total_days_per_state = {[state, total_days], [state, total_days]}
	# 	# {
	# 	# 	CA: 180,
	# 	# 	FL: 180,
	# 	# 	NY: 5
	# 	# }

	# 	if leap_year?
	# 		max >== 184
	# 	else
	# 		max >== 183
	# 	end
	# end

	# def total_days_per_state({[location, total_days]})
	# 	@final_count = {}

	# 	@trips.each do |trip|
	# 		@final_count[trip.location] = total_days
	# 	end
	# end
	# # takes in a hash of arrays of @person.trips
	# # @person.trips.(total_days, location)
	# # returns a hash of arrays

end
