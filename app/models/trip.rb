class Trip < ActiveRecord::Base
	belongs_to :person
	validates_presence_of :start_date, :end_date, :total_days
	validate :state_abbreviated

	# validation methods
	def state_abbreviated
		if state.nil? || (state.upcase != state) || (state.length != 2) 
			errors.add(:state, "Please write your state in the form of 2 abbreviated, capital letters.")
		end
	end
end
