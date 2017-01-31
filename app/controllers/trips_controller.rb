class TripsController < ApplicationController
	before_action :set_year_analysis
	
	def new
		time_accounted_for
	end
	
	def create
		@trips = @year_analysis.trips
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
			redirect_to year_analysis_path(@year_analysis)
		end
	end

	def index
		@trips = @year_analysis.trips
	end

	private

	def time_accounted_for
		@time_accounted_for = []

		if params[:trips].blank?
			21.times{@time_accounted_for.push(@year_analysis.trips.new)}
		else
			params[:trips].each do |trip|
				@time_accounted_for.push(@year_analysis.trips.new(trip_params(trip)))
			end
		end
	end

	def set_year_analysis
		@year_analysis = YearAnalysis.find(params[:year_analysis_id])
	end

	def trip_params(trip)
		trip.permit(:start_date, :end_date, :state, :total_days)
	end

end