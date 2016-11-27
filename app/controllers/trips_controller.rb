require 'gruff'

class TripsController < ApplicationController
	before_action :set_person
	before_action :trip_summary_data, only: [:index, :pie_chart_for_total_days_per_state]
	
	def new
		time_accounted_for
	end
	
	def create
		@trips = @person.trips
		params[:trips] = params[:trips].take_while{|t| !t.values.all?(&:empty?)}

		begin
			@trips.new.save! if params[:trips].empty?

			ActiveRecord::Base.transaction do
				params[:trips].each do |trip|
			    	@trips.new(trip_params(trip)).save!
			    end
			end
		rescue ActiveRecord::RecordInvalid => invalid
			@errors = invalid.record.errors.full_messages
			time_accounted_for
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

	def time_accounted_for
		@time_accounted_for = []

		if params[:trips].blank?
			21.times{@time_accounted_for.push(@person.trips.new)}
		else
			params[:trips].each do |trip|
				@time_accounted_for.push(@person.trips.new(trip_params(trip)))
			end
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