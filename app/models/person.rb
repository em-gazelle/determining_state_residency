class Person < ActiveRecord::Base
	validates :year, presence: :true, numericality: { greater_than: 0 }
	validates :desired_state_of_residency, presence: :true, state: true

	before_save :leap_year?

	has_many :trips, dependent: :destroy

	protected

		def leap_year?
			self.leap_year = Date.leap?(self.year)
			true
		end
end
