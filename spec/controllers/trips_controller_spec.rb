require 'rails_helper'

RSpec.describe TripsController, type: :controller do
	let(:person) { Fabricate(:person) }
	let(:residency_achieved_conclusion) { "Congrats! You've achieved residency in your desired state!" }
	let(:desired_state_of_residency) { "CA" }
	let(:trips_aggregated) do
		{
			"CA" => 190,
			"FL" => 133,
			"Rest of the Year" => 42
		}
	end
	let(:expected_trip_summary_data) do
		{
			total_days_per_state: trips_aggregated,
			residency_conclusion: residency_achieved_conclusion
		}
	end

	describe 'index' do
		before do 
			Fabricate(:person, desired_state_of_residency: "CA", year: 2014, id: 1) do
			 	trips { 
			  		[
				  		Fabricate(:trip, state: "CA", total_days: 179, person_id: 1), 
				  		Fabricate(:trip, state: "FL", total_days: 133, person_id: 1), 
				  		Fabricate(:trip, state: "CA", total_days: 11, person_id: 1)  		
				  	]
				}
			end
		end

		context 'at least one trip supplied, no errors' do
			it 'returns trip summary data' do
				get :index, person_id: 1
				expect(assigns(:trip_summary_data)).to eq(expected_trip_summary_data)
			end
		end
		context 'no trips entered' do
			it 'throws error and redirects user to person/#/trips/new' do
			end
		end
	end

end