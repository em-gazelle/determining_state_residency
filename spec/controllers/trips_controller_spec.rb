require 'rails_helper'

RSpec.describe TripsController, type: :controller do
	let(:person) { Fabricate(:person) }
	let(:trip_a) do 
		{
			total_days_per_trip: 179,
			state: "CA"
		}
	end	
	let(:trip_b) do {
			total_days_per_trip: 133,
			state: "FL"
		}
	end
	let(:trip_c) do {
			total_days_per_trip: 11,
			state: "CA"
		}
	end
	let(:desired_state_of_residency) { "CA" }

	let(:trip_params) do {
		"trips" => [trip_a, trip_b, trip_c
		],
		"person_id" => person.id
	}
	end
	let(:trips_aggregated) do
		{
			"CA" => 190,
			"FL" => 133
		}
	end


	describe 'total_days_per_state(trips)' do
		context 'with 2+ trips/person, perfect case' do
			it 'calculates total days / state' do
				expect(TripsController.new.total_days_per_state(trip_params, desired_state_of_residency)).to eq(trips_aggregated)
			end
			it 'calculates days remaining' do
				expect(TripsController.new.days_remaining(trips_aggregated)).to eq(42)
			end
			it 'returns residency conclusion to show on view, including a calculation of how to achieve residency' do
				expect(TripsController.new.residency_conclusion(trips_aggregated, desired_state_of_residency)).to eq("Congrats! You've achieved residency in your desired state!")
			end
		end
	end
end