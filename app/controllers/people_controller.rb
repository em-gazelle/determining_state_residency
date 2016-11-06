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