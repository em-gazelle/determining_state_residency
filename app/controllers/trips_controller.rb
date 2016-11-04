class TripsController < ApplicationController
	before_action :set_person, only: [:new, :create, :index]
	
	def new 
		@time_accounted_for = []
		3.times do
			@time_accounted_for << @person.trips.new
		end
	end

	def index
		@trips = @person.trips
	end
	# what I want to retrieve.....to display as variables in the view:
	# @trips.residency_conclusion + @trips.total_days_per_state => pie chart

	
	def create

		params[:trips].each do |trip|
			trip[:total_days] = (trip[:end_date].to_date - trip[:start_date].to_date).to_i
			# convert to model method!!!
			trip = @person.trips.create!(trip_params(trip))
		end

		redirect_to person_trips_path
	end



	def total_days_per_state(trips, desired_resident_state)
		all_trips = trips["trips"]

		@total_days_per_state = {
			desired_resident_state => 0
		}

		all_trips.each do |trip|
			state = trip[:state]
			@total_days_per_state[state] = trip[:total_days_per_trip] + (@total_days_per_state[state] || 0)
		end
		@total_days_per_state
	end


	def days_remaining(total_days_per_state)
		days_entered = ( total_days_per_state.map {|k,v| v}.sum )
		365 - days_entered
	end



	def residency_conclusion(total_days_per_state, desired_resident_state)
		min_days_to_be_resident = (183 - total_days_per_state[desired_resident_state])
		max_days_left_in_other_states = (days_remaining(total_days_per_state) - min_days_to_be_resident)

		@residency_conclusion = if min_days_to_be_resident <= 0
									"Congrats! You've achieved residency in your desired state!"
								elsif min_days_to_be_resident > 0 && (min_days_to_be_resident > days_remaining)
									"Sorry, kiddo. Ya ain't gonna make your dreams come true; there aren't enough days left in the 
									year to achieve residency in your dream-residency state"
								else
									"You've got to spend at least #{min_days_to_be_resident} days in #{desired_residency} in order
									to achieve residency. You can spend a maximum of #{max_days_left_in_other_states} anywhere else."
								end
	end	


	private

	def set_person
		@person = Person.find(params[:person_id])
	end

	def trip_params(my_params)
		my_params.permit(:start_date, :end_date, :state, :total_days)
	end

end