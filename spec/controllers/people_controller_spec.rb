require 'rails_helper'

RSpec.describe PeopleController, type: :controller do
	let(:person_params) do
		{
			desired_state_of_residency: "TX",
			year: 2018
		}
	end

	describe 'create#POST' do
		it 'creates a new person' do
		  expect{
		    post :create, person: person_params
		  }.to change(Person,:count).by(1)
		end
		it 'calculates and sets leap_year attribute from year when creating a person' do
		    post :create, person: person_params
	    	expect(Person.last.leap_year.nil?).to eq(false)
		end
	end
end