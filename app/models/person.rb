class Person < ActiveRecord::Base
	validates :year, presence: :true, numericality: { greater_than: 0 }
	validate :state_abbreviated


	has_many :trips do
		def total_days_per_state(desired_state_of_residency)
			@total_days_per_state = {
				desired_state_of_residency => 0
			}

			self.each do |trip|
				state = trip[:state]
				@total_days_per_state[state] = trip[:total_days] + (@total_days_per_state[state] || 0)
			end

			@total_days_per_state
		end

		def days_remaining
			days_entered = ( @total_days_per_state.map {|k,v| v}.sum )
			365 - days_entered
		end

		def residency_conclusion(desired_state_of_residency)
			min_days_to_be_resident = (183 - @total_days_per_state[desired_state_of_residency])
			max_days_left_in_other_states = (days_remaining - min_days_to_be_resident)

			if min_days_to_be_resident <= 0
				"Congrats! You've achieved residency in your desired state!"
			elsif min_days_to_be_resident > 0 && (min_days_to_be_resident > days_remaining)
				"Sorry, kiddo. Ya ain't gonna make your dreams come true; there aren't enough days left in the 
				year to achieve residency in your dream-residency state"
			else
				"You've got to spend at least #{min_days_to_be_resident} days in #{desired_residency} in order
				to achieve residency. You can spend a maximum of #{max_days_left_in_other_states} anywhere else."
			end
		end

		def trip_summary_data(desired_state_of_residency)
			{
				total_days_per_state: total_days_per_state(desired_state_of_residency),
				residency_conclusion: residency_conclusion(desired_state_of_residency)
			}
		end
	end


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
