class Person < ActiveRecord::Base
	validates :year, presence: :true, numericality: { greater_than: 0 }
	validate :state_abbreviated	

	has_many :trips
	

	# validation methods
	def state_abbreviated
		if (desired_state_of_residency.upcase != desired_state_of_residency) || (desired_state_of_residency.length != 2)
			errors.add(:desired_state_of_residency, "Please supply your desired state of residency in the form of 2 abbreviated, capital letters.")
		end
	end

	# defining attribute methods
	def leap_year?(year)
		year = year.to_i
		divisible_by_100 = (year%100).zero?

		if divisible_by_100 && (year%400).zero?
			self.leap_year = true
		elsif (year%4).zero? && !divisible_by_100
			self.leap_year = true
		else
			self.leap_year = false
		end
	end
	# Rules for calculating leap years found at: http://www.timeanddate.com/date/leapyear.html

end
