class TripsController < ApplicationController
	before_action :set_person, only: [:new, :create, :index]
	
	def new 
		@time_accounted_for = []
		3.times do
			@time_accounted_for << @person.trips.new
		end
	end
	
	def create

		params[:trips].each do |trip|
			trip[:total_days] = (trip[:end_date].to_date - trip[:start_date].to_date).to_i
			# convert to model method!!!
			trip = @person.trips.create!(trip_params(trip))
		end

		redirect_to person_trips_path
	end

	def index
		@trips = @person.trips
		@trip_summary_data = @person.trips.trip_summary_data(@person.desired_state_of_residency)
	end



	private

	def set_person
		@person = Person.find(params[:person_id])
	end

	def trip_params(my_params)
		my_params.permit(:start_date, :end_date, :state, :total_days)
	end

end