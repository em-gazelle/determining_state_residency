require 'rails_helper'

RSpec.describe TripsController, type: :controller do
	let(:person) { Fabricate(:person) }

	# let(:trips_aggregated) do
	# 	{
	# 		"NY" => 80,
	# 		"WY" => 245,
	# 		"Rest of the Year" => 40
	# 	}
	# end
	# let(:expected_trip_summary_data) do
	# 	{
	# 		total_days_per_state: trips_aggregated,
	# 		residency_conclusion: "Congrats! You've achieved residency in WY!",
	# 		min_days_to_be_resident: -62,
	# 		max_days_left_in_other_states: 102
	# 	}
	# end
	# let(:expected_trip_summary_data_when_empty) do
	# 	{
	# 		total_days_per_state: { "Rest of the Year" => 365, "CA" => 0 },
	# 		residency_conclusion: "Oops! Looks like you haven't added any information on how you've spent the year... you've gotta give a little to get! Right now all we can say is the standard: you'll need to spend at least 183 days in #{person.desired_state_of_residency} in order to achieve residency!",
	# 		min_days_to_be_resident: 183,
	# 		max_days_left_in_other_states: 182
	# 	}
	# end
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

	describe 'post' do
		context 'when form is empty / no trips entered' do
			it 'throws error and does not add any trips' do
				expect{
					post :create, person_id: person.id, trips: [3.times {empty_trip_params} ]
				}.to rescue ActiveRecord::RecordInvalid
			end
			it 'does not add any trips' do
				expect{
					post :create, person_id: person.id, trips: [empty_trip_params, empty_trip_params, empty_trip_params]
				}.to change(Trip, :count).by(0)
			end
		end
		context 'when form is not fully filled out, but at least one is partially completed' do
			it 'adds 2 trips and throws no errors' do
				expect{
					post :create, person_id: person.id, trips: trip_params[0..1].push(empty_trip_params)
				}.to change(Trip, :count).by(2)
			end
			it 'calculates and assigns the field total_days to each trip' do
				post :create, person_id: person.id, trips: trip_params[0..1].push(empty_trip_params)
				expect(Person.find(person.id).trips.pluck(:total_days)).to eq([64, 25])
			end
		end
		context 'when form has 1 trip completely filled out and 1 that is only partially filled out' do
			it 'throws error' do
				expect{
					post :create, person_id: person.id, trips: trip_params[0..1].push(invalid_trip_params)
				}.to rescue ActiveRecord::RecordInvalid
			end
			it 'does not add any trips' do
				expect{
					post :create, person_id: person.id, trips: trip_params[0..1].push(invalid_trip_params)
				}.to change(Trip, :count).by(0)
			end

		end
		context 'when all forms are fully filled out / 3 trips entered' do
			it 'adds all 3 trips' do
				expect{
					post :create, person_id: person.id, trips: trip_params.first(3)
				}.to change(Trip, :count).by(3)
			end
		end

		context 'when user clicks to add more trips to form / more than 3 trips entered' do
			it 'adds 4 trips' do
				expect{
					post :create, person_id: person.id, trips: trip_params
				}.to change(Trip, :count).by(4)
			end
		end
	end

	# describe 'index' do
	# 	before do 
	# 		Fabricate(:person, desired_state_of_residency: "WY", year: 2014, id: 1) do
	# 		 	trips { 
	# 		  		[

	# 			  		Fabricate(:trip, state: "WY", start_date: Date.today-365, end_date: Date.today-180, person_id: 1), 
	# 			  		Fabricate(:trip, state: "NY", start_date: Date.today-180, end_date: Date.today-100, person_id: 1), 
	# 			  		Fabricate(:trip, state: "WY", start_date: Date.today-100, end_date: Date.today-40, person_id: 1)  		
	# 			  	]
	# 			}
	# 		end
	# 	end

	# 	context 'at least one trip supplied, no errors' do
	# 		it 'returns trip summary data' do
	# 			get :index, person_id: 1
	# 			expect(assigns(:trip_summary_data)).to eq(expected_trip_summary_data)
	# 		end
	# 	end
	# 	context 'no trips entered' do
	# 		it 'raises no errors and displays the add-more-trips residency conclusion with a pie-chart consisting of only "rest of year"' do
	# 			get :index, person_id: person.id
	# 			expect(assigns(:trip_summary_data)).to eq(expected_trip_summary_data_when_empty)
	# 		end
	# 	end
	# end

end