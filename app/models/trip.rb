class Trip < ActiveRecord::Base
	belongs_to :year_analysis
	
	validates_presence_of :start_date, :end_date
	validates :state, state: true
	validate :validating_dates

	before_create :set_total_days, on: :create
	before_save :set_total_days, on: :update

	def validating_dates
		if start_date.nil? || end_date.nil? || (end_date < start_date)
			errors.add(:end_date, "must be ahead of start date")
		end
	end

	protected
		def set_total_days
			self.total_days = (self.end_date - self.start_date).to_i
		end

end