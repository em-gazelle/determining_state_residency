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
end