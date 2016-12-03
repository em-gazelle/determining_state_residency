class Person < ActiveRecord::Base
	validates :year, presence: :true, numericality: { greater_than: 0 }
	validates :desired_state_of_residency, presence: :true, state: true

	before_save :leap_year?

	has_many :trips, dependent: :destroy do

		def total_days_per_state(desired_state_of_residency)
			@total_days_per_state = self.group(:state).sum(:total_days)
			@total_days_per_state["Rest of the Year"] = @days_remaining unless days_remaining < 1
			@total_days_per_state
		end

		def days_remaining
			@days_remaining = 365 - ( @total_days_per_state.map {|k,v| v}.sum )
		end

		def residency_conclusion(desired_state_of_residency)
			return "Oops! Looks like you haven't added any information on how you've spent the year... you've gotta give a little to get! Right now all we can say is the standard: you'll need to spend at least 183 days in #{desired_state_of_residency} in order to achieve residency!" if self.blank?
			min_days_to_be_resident = (183 - (@total_days_per_state[desired_state_of_residency] ||= 0))
			max_days_left_in_other_states = (@days_remaining - min_days_to_be_resident)

			if min_days_to_be_resident <= 0
				"Congrats! You've achieved residency in #{desired_state_of_residency}!"
			elsif min_days_to_be_resident > 0 && (min_days_to_be_resident > @days_remaining)
				"Sorry, kiddo. Ya ain't gonna make your dreams come true; there aren't enough days left in the 
				year to achieve residency in #{desired_state_of_residency}"
			else
				"You need to spend at least #{min_days_to_be_resident} more days in #{desired_state_of_residency} in order
				to achieve residency. You can spend a maximum of #{max_days_left_in_other_states} days anywhere else."
			end
		end

		def trip_summary_data(desired_state_of_residency)
			{
				total_days_per_state: total_days_per_state(desired_state_of_residency),
				residency_conclusion: residency_conclusion(desired_state_of_residency)
			}
		end
	end

	protected

		def leap_year?			
			divisible_by_100 = (self.year%100).zero?

			if (divisible_by_100 && (self.year%400).zero?) || ((self.year%4).zero? && !divisible_by_100)
				self.leap_year = true
			else
				self.leap_year = false
			end
			true
		end
		# Rules for calculating leap years found at: http://www.timeanddate.com/date/leapyear.html

end
