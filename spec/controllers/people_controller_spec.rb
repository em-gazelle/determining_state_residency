require 'rails_helper'

RSpec.describe PeopleController, type: :controller do
	let(:desired_state_residency) { "TX" }
	let(:missing_year_params) do
		{
			desired_state_of_residency: "IL"
		}
	end
	let(:invalid_state_params) do
		{
			year: 1999,
			desired_state_of_residency: "oh"
		}
	end

	describe 'create#POST' do

		context 'invalid params are supplied' do
			it 'throws an error if params are missing' do
				person = Person.create(missing_year_params)
				person.valid?
				expect(person.errors).to have_key(:year)
			end
			it 'throws error if state of residency is not abbreviated and in caps' do
				person = Person.create(invalid_state_params)
				person.valid?
				expect(person.errors).to have_key(:desired_state_of_residency)
			end
		end

		context 'attributes of year and desired state residency are valid and present' do
			it 'creates a new person' do
			  expect{
			    post :create, person: { desired_state_of_residency: desired_state_residency, year: 2016}
			  }.to change(Person,:count).by(1)
			end
			it 'calculates and sets leap_year attribute from year when creating a person' do
		    	post :create, person: { desired_state_of_residency: desired_state_residency, year: 44444}
		    	expect(Person.last.leap_year.nil?).to eq(false)
			end
		end
	end 

end