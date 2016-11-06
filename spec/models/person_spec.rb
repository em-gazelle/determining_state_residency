require 'rails_helper'

RSpec.describe Person, type: :model do
	let(:person) { Person.new }

	describe 'validations' do
		it 'is invalid without year' do
			expect(Fabricate.build(:person, year: nil)).to_not be_valid
		end
		it 'is invalid if state is not abbreviated and in all caps' do
			expect(Fabricate.build(:person, desired_state_of_residency: "ca")).to_not be_valid
			expect(Fabricate.build(:person, desired_state_of_residency: "CALIFORNIA")).to_not be_valid
		end
	end

	describe 'leap_year?(year)' do
		it 'returns false when not divisible by 4' do
			expect(person.leap_year?(2011)).to be false
		end
		it 'returns false when divisible by 4 & 100, but not by 400' do
			expect(person.leap_year?(1900)).to be false
		end
		it 'returns true when divisible by 4, 100, and 400' do
			expect(person.leap_year?(2000)).to be true
		end
		it 'returns true when divisible by 4, but not by 100' do
			expect(person.leap_year?(2016)).to be true
		end
	end
	
end