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

end
