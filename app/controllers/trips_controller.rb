require 'gruff'

class TripsController < ApplicationController
	before_action :set_person
	before_action :trip_summary_data, only: [:index, :pie_chart_for_total_days_per_state]
	
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

	private

	def set_person
		@person = Person.find(params[:person_id])
	end

	def trip_params(my_params)
		my_params.permit(:start_date, :end_date, :state, :total_days)
	end

	def trip_summary_data
		@trip_summary_data = @person.trips.trip_summary_data(@person.desired_state_of_residency)
	end

end