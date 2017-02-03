require 'rails_helper'

RSpec.describe TripsController, type: :controller do
	let(:user) { Fabricate(:user) }
	let(:year_analysis) { Fabricate(:year_analysis) }

	let(:trip_params) do
		[
			{"start_date"=>"2016-01-01", "end_date"=>"2016-03-05", "state"=>"WY"},
			{"start_date"=>"2016-03-05", "end_date"=>"2016-03-30", "state"=>"NY"},
			{"start_date"=>"2016-03-30", "end_date"=>"2016-10-28", "state"=>"WY"},
			{"start_date"=>"2016-10-28", "end_date"=>"2016-12-31", "state"=>"FL"}
		]
	end
	let(:empty_trip_params) do
		{"start_date"=>"", "end_date"=>"", "state"=>""}
	end	
	let(:invalid_trip_params) do
		{"start_date"=>"2016-01-01", "end_date"=>"2016-03-05", "state"=>""}
	end

	before(:each) do
		sign_in user
	end

	describe 'post' do
		context 'when form is empty / no trips entered' do
			it 'throws error and does not add any trips' do
				expect{
					post :create, year_analysis_id: year_analysis.id, trips: [3.times {empty_trip_params} ]
				}.to rescue ActiveRecord::RecordInvalid
			end
			it 'does not add any trips' do
				expect{
					post :create, year_analysis_id: year_analysis.id, trips: [empty_trip_params, empty_trip_params, empty_trip_params]
				}.to change(Trip, :count).by(0)
			end
		end
		context 'when form is not fully filled out, but at least one is partially completed' do
			it 'adds 2 trips and throws no errors' do
				expect{
					post :create, year_analysis_id: year_analysis.id, trips: trip_params[0..1].push(empty_trip_params)
				}.to change(Trip, :count).by(2)
			end
			it 'calculates and assigns the field total_days to each trip' do
				post :create, year_analysis_id: year_analysis.id, trips: trip_params[0..1].push(empty_trip_params)
				expect(YearAnalysis.find(year_analysis.id).trips.pluck(:total_days)).to eq([64, 25])
			end
		end
		context 'when form has 1 trip completely filled out and 1 that is only partially filled out' do
			it 'throws error' do
				expect{
					post :create, year_analysis_id: year_analysis.id, trips: trip_params[0..1].push(invalid_trip_params)
				}.to rescue ActiveRecord::RecordInvalid
			end
			it 'does not add any trips' do
				expect{
					post :create, year_analysis_id: year_analysis.id, trips: trip_params[0..1].push(invalid_trip_params)
				}.to change(Trip, :count).by(0)
			end

		end
		context 'when all forms are fully filled out / 3 trips entered' do
			it 'adds all 3 trips' do
				expect{
					post :create, year_analysis_id: year_analysis.id, trips: trip_params.first(3)
				}.to change(Trip, :count).by(3)
			end
		end

		context 'when user clicks to add more trips to form / more than 3 trips entered' do
			it 'adds 4 trips' do
				expect{
					post :create, year_analysis_id: year_analysis.id, trips: trip_params
				}.to change(Trip, :count).by(4)
			end
		end
	end

end