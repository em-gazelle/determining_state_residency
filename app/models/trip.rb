class Trip < ActiveRecord::Base
	belongs_to :person
	
	validates_presence_of :start_date, :end_date
	validate :state_abbreviated
	validate :validating_dates

	before_create :set_total_days, on: [ :create ]

	def validating_dates
		if start_date.nil? || end_date.nil? || (end_date < start_date)
			errors.add(:end_date, "must be ahead of start date")
		end		
	end

	def state_abbreviated
		if state.nil? || (state.upcase != state) || (state.length != 2) 
			errors.add(:state, "must be supplied in the form of 2 abbreviated, capital letters.")
		end
	end

	protected
		def set_total_days
			self.total_days = (self.end_date - self.start_date).to_i
		end

end