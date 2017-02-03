class YearAnalysesController < ApplicationController
	before_action :set_year_analysis, except: [:new, :create]
	before_action :trip_summary_data, only: [:show, :pie_chart_for_total_days_per_state]

	def new
		@year_analysis = YearAnalysis.new
	end

	def create
		@year_analysis = YearAnalysis.new(year_analysis_params)

		respond_to do |format|
			if @year_analysis.save
		        format.html { redirect_to new_year_analysis_trip_path(@year_analysis) }
		        format.json 
			else
		        format.html { render :new }
		        format.json { render json: @year_analysis.errors, status: :unprocessable_entity }				
			end
		end
	end

	def edit
	end

	def update
		if @year_analysis.update(year_analysis_params)
			redirect_to year_analysis_trips_path(@year_analysis)
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
		@year_analysis.destroy
		redirect_to new_year_analysis_path
	end

	private

	def set_year_analysis
		@year_analysis = YearAnalysis.find(params[:id])
	end

	def year_analysis_params
		params.require(:year_analysis).permit(:year, :desired_state_of_residency)
	end

	def trip_summary_data
		@trip_summary_data = @year_analysis.trip_summary_data
	end

end