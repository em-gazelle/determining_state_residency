class PeopleController < ApplicationController
	before_action :set_person, only: [:show, :destroy]

	def new
		@person = Person.new
	end

	def create
		@person = Person.new(person_params)
		@person[:leap_year] = @person.leap_year?(@person.year)

		respond_to do |format|
			if @person.save
		        format.html { redirect_to new_person_trip_path(@person) }
		        format.json 
			else
		        format.html { render :new }
		        format.json { render json: @person.errors, status: :unprocessable_entity }				
			end
		end
	end

	def show
		@trips = @person.trips

		# model association (collection??) methods....
		@total_days_per_state = @trips.total_days_per_state
		# call in pie chart and/or brief recapping-list
		@residency_conclusion = @trips.residency_conclusion
		# call in view as display message
	end

	def destroy
	end

	private

	def set_person
		@person = Person.find(params[:id])
	end

	def person_params
		params.require(:person).permit(:year, :desired_state_of_residency)
	end

end