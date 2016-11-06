require 'rails_helper'

RSpec.describe Trip, type: :model do
	describe 'validations' do
		it 'is invalid without state, start_date, or end_date' do
			expect(Fabricate.build(:trip, state: nil)).to_not be_valid
			expect(Fabricate.build(:trip, start_date: nil)).to_not be_valid
			expect(Fabricate.build(:trip, end_date: nil)).to_not be_valid
		end
		it 'is invalid without total_days field' do
			expect(Fabricate.build(:trip, total_days: nil)).to_not be_valid
		end
	end
end
