class PeopleController < ApplicationController
	before_action :set_person, except: [:new, :create]
	before_action :trip_summary_data, only: [:show, :pie_chart_for_total_days_per_state]


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

	def show
	end

	def pie_chart_for_total_days_per_state
		graph = Gruff::Pie.new(600)
		graph.theme = Gruff::Themes::PASTEL
		graph.title = "Where you've spent the year: days per state"
		
		@trip_summary_data[:total_days_per_state].each do |state|
			graph.data(state[0], state[1])
		end
		send_data(graph.to_blob, :disposition => 'inline',  :type => 'image/png',  :filename => "pie.png")
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

	def trip_summary_data
		@trip_summary_data = @person.trip_summary_data
	end

end