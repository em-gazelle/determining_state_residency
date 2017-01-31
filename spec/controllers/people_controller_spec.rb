require 'rails_helper'

RSpec.describe PeopleController, type: :controller do
	let(:person_params) do
		{
			desired_state_of_residency: "TX",
			year: 2018
		}
	end

	let(:person) { Fabricate(:person) }

	let(:trips_aggregated) do
		{
			"NY" => 80,
			"WY" => 245,
			"Rest of the Year" => 40
		}
	end
	let(:expected_trip_summary_data) do
		{
			total_days_per_state: trips_aggregated,
			residency_conclusion: "Congrats! You've achieved residency in WY!",
			min_days_to_be_resident: -62,
			max_days_left_in_other_states: 102
		}
	end
	let(:expected_trip_summary_data_when_empty) do
		{
			total_days_per_state: { "Rest of the Year" => 365, "CA" => 0 },
			residency_conclusion: "Oops! Looks like you haven't added any information on how you've spent the year... you've gotta give a little to get! Right now all we can say is the standard: you'll need to spend at least 183 days in #{person.desired_state_of_residency} in order to achieve residency!",
			min_days_to_be_resident: 183,
			max_days_left_in_other_states: 182
		}
	end	

	describe 'create#POST' do
		it 'creates a new person' do
		  expect{
		    post :create, person: person_params
		  }.to change(Person,:count).by(1)
		end
		
		it 'sets leap_year as false when not divisible by 4' do
		    post :create, person: {desired_state_of_residency: "LA", year: 2011, id: 1}			
			expect(Person.first.leap_year).to eq(false)
		end
		it 'sets leap_year as false when divisible by 4 & 100, but not by 400' do
		    post :create, person: {desired_state_of_residency: "LA", year: 1900, id: 1}			
			expect(Person.first.leap_year).to eq(false)
		end
		it 'sets leap_year as true when divisible by 4, 100, and 400' do
		    post :create, person: {desired_state_of_residency: "LA", year: 2000, id: 1}			
			expect(Person.first.leap_year).to eq(true)
		end
		it 'sets leap_year as true when divisible by 4, but not by 100' do
		    post :create, person: {desired_state_of_residency: "LA", year: 2016, id: 1}			
			expect(Person.first.leap_year).to eq(true)
		end
	end

	describe 'show' do
		before do 
			Fabricate(:person, desired_state_of_residency: "WY", year: 2014, id: 1) do
			 	trips { 
			  		[

				  		Fabricate(:trip, state: "WY", start_date: Date.today-365, end_date: Date.today-180, person_id: 1), 
				  		Fabricate(:trip, state: "NY", start_date: Date.today-180, end_date: Date.today-100, person_id: 1), 
				  		Fabricate(:trip, state: "WY", start_date: Date.today-100, end_date: Date.today-40, person_id: 1)  		
				  	]
				}
			end
		end

		context 'at least one trip supplied, no errors' do
			it 'returns trip summary data' do
				get :show, id: 1
				expect(assigns(:trip_summary_data)).to eq(expected_trip_summary_data)
			end
		end
		context 'no trips entered' do
			it 'raises no errors and displays the add-more-trips residency conclusion with a pie-chart consisting of only "rest of year"' do
				get :show, id: person.id
				expect(assigns(:trip_summary_data)).to eq(expected_trip_summary_data_when_empty)
			end
		end
	end

end