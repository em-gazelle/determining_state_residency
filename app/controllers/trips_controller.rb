require 'gruff'

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
			trip = @person.trips.create!(trip_params(trip))
		end

		redirect_to person_trips_path
	end

	def index
		@trips = @person.trips
		@trip_summary_data = @person.trips.trip_summary_data(@person.desired_state_of_residency)
		
		pie_chart_for_total_days_per_state
	end

	private

	def set_person
		@person = Person.find(params[:person_id])
	end

	def trip_params(my_params)
		my_params.permit(:start_date, :end_date, :state, :total_days)
	end


	def pie_chart_for_total_days_per_state
			g = Gruff::Pie.new(600)
			g.theme = Gruff::Themes::PASTEL
			g.title = "Where you've spent the year: days per state"
			@trip_summary_data[:total_days_per_state].each do |state|
				g.data(state[0], state[1])
			end
			g.write('app/assets/pie_charts/residency_by_state_pie_chart.png')
	end

end