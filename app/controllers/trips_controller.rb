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
		@trips = @person.trips
		@all_empty = params[:trips].first.values.all?(&:blank?)

		begin
			ActiveRecord::Base.transaction do  
				params[:trips].each do |trip|
					break if trip.values.all?(&:blank?) unless @all_empty
					trip[:total_days] = total_days(trip[:start_date], trip[:end_date])
			    	@trips.new(trip_params(trip)).save!
			    end
			end
		rescue ActiveRecord::RecordInvalid => invalid
			@errors = invalid.record.errors.full_messages
			render :new
		else
			redirect_to person_trips_path
		end
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

	def total_days(start_date, end_date)
		if !start_date.blank? && !end_date.blank?
			(end_date.to_date - start_date.to_date).to_i
		end
	end

	def set_person
		@person = Person.find(params[:person_id])
	end

	def trip_params(trip)
		trip.permit(:start_date, :end_date, :state, :total_days)
	end

	def trip_summary_data
		@trip_summary_data = @person.trips.trip_summary_data(@person.desired_state_of_residency)
	end

end