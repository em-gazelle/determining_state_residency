require 'rails_helper'

RSpec.describe YearAnalysis, type: :model do
	let(:year_analysis) { YearAnalysis.new }

	describe 'validations' do
		it 'is invalid without year' do
			expect(Fabricate.build(:year_analysis, year: nil)).to_not be_valid
		end
		it 'is invalid if state is not abbreviated and in all caps' do
			expect(Fabricate.build(:year_analysis, desired_state_of_residency: "ca")).to_not be_valid
			expect(Fabricate.build(:year_analysis, desired_state_of_residency: "CALIFORNIA")).to_not be_valid
		end
	end
	
end