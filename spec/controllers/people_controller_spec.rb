require 'rails_helper'

RSpec.describe PeopleController, type: :controller do
	let(:year_not_div_by_4) { 2011 }
	let(:year_div_by_4_not_100) { 2016 }
	let(:year_div_by_100_not_400) { 1900 }
	let(:year_div_by_400) { 2000 }
	let(:desired_state_residency) { "TX" }
	let(:missing_params) do
		{
			desired_state_of_residency: "IL"
		}
	end
	let(:invalid_params) do
		{
			year: 1999,
			desired_state_of_residency: "oh"
		}
	end

	describe 'create#POST' do

		context 'invalid params are supplied' do
			it 'throws an error if params are missing' do
				person = Person.create(missing_params)
				person.valid?
				expect(person.errors).to have_key(:year)
			end
			it 'throws error if state of residency is not abbreviated and in caps' do
				person = Person.create(invalid_params)
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
			it 'returns success' do
				post :create, person: { desired_state_of_residency: desired_state_residency, year: 2016}
				expect(response).to be(200)
			end
			# it 'returns false when not divisible by 4' do
			# 	post :create, person: { desired_state_of_residency: desired_state_residency, year: year_not_div_by_4 }
			# 	expect(Person.last.leap_year).to be false
			# end
			# it 'returns false when divisible by 4 & 100, but not by 400' do
			# 	post :create, person: { desired_state_of_residency: desired_state_residency, year: year_div_by_100_not_400 }
			# 	expect(Person.last.leap_year).to be false
			# end
			# it 'returns true when divisible by 4, 100, and 400' do
			# 	post :create, person: { desired_state_of_residency: desired_state_residency, year: year_div_by_400 }
			# 	expect(Person.last.leap_year).to be true			
			# end
			# it 'returns true when divisible by 4, but not by 100' do
			# 	post :create, person: { desired_state_of_residency: desired_state_residency, year: year_div_by_4_not_100 }
			# 	expect(Person.last.leap_year).to be true	
			# end
		end
	end 

end