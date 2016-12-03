class PeopleController < ApplicationController
	before_action :set_person, only: [:edit, :update, :destroy]

	def new
		@person = Person.new
	end

	def create
		@person = Person.new(person_params)

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

	def edit
	end

	def update
		if @person.update(person_params)
			redirect_to person_trips_path(@person)
		else
			render 'edit'
		end
	end

	def destroy
		@person.destroy
		redirect_to new_person_path
	end

	private

	def set_person
		@person = Person.find(params[:id])
	end

	def person_params
		params.require(:person).permit(:year, :desired_state_of_residency)
	end

end