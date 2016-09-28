class TripsController < ApplicationController
	before_action :set_person, only: [:new, :index]
	
	def new 
		@trip = @person.trips.new
	end

	def index
		@trips = @person.trips
	end
	
	def create
		@trip = @person.trips.new(trip_params)
		@trip.total_days = @trip.total_days_per_trip(@trip.start_date, @trip.end_date)
		
		respond_to do |format|
			if @trip.save
				format.html { redirect_to person_trips_path }
				format.json { render :index }
			else
				format.html { render :new }
				format.json { render json: @trip.errors, status: :unprocessable_entity }
			end
		end
	end


	private

	def set_person
		@person = Person.find(params[:person_id])
	end

	def trip_params
		params.require(:trip).permit(:start_date, :end_date, :state)
	end

end