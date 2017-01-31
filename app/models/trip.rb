class Trip < ActiveRecord::Base
	belongs_to :person
	
	validates_presence_of :start_date, :end_date
	validates :state, state: true
	validate :validating_dates

	before_create :set_total_days, on: [ :create ]

	def validating_dates
		if start_date.nil? || end_date.nil? || (end_date < start_date)
			errors.add(:end_date, "must be ahead of start date")
		end		
	end

	# analyze trips : model methods
	def self.total_days_per_state
		puts "in tdps method"
		@total_days_per_state = self.group(:state).sum(:total_days)
		@total_days_per_state["Rest of the Year"] = @days_remaining unless days_remaining < 1
		@total_days_per_state
	end

	def self.days_remaining
		@days_remaining = days_of_year - ( @total_days_per_state.map {|k,v| v}.sum )
	end

	def self.days_of_year
		if @leap_year
			366
		else
			365
		end
	end
	
	def self.majority_of_year
		((days_of_year/2)+1).round
	end

	def self.residency_conclusion
		@min_days_to_be_resident = (majority_of_year - (@total_days_per_state[@desired_state_of_residency] ||= 0))
		@max_days_left_in_other_states = (@days_remaining - @min_days_to_be_resident)

		if @min_days_to_be_resident == majority_of_year
			"Oops! Looks like you haven't added any information on how you've spent the year... you've gotta give a little to get! Right now all we can say is the standard: you'll need to spend at least #{majority_of_year} days in #{@desired_state_of_residency} in order to achieve residency!"
		elsif @min_days_to_be_resident <= 0
			"Congrats! You've achieved residency in #{@desired_state_of_residency}!"
		elsif @min_days_to_be_resident > 0 && (@min_days_to_be_resident > @days_remaining)
			"Sorry, kiddo. Ya ain't gonna make your dreams come true; there aren't enough days left in the 
			year to achieve residency in #{@desired_state_of_residency}"
		else
			"You need to spend at least #{@min_days_to_be_resident} more days in #{@desired_state_of_residency} in order
			to achieve residency. You can spend a maximum of #{@max_days_left_in_other_states} days anywhere else."
		end
	end

	def self.trip_summary_data(desired_state_of_residency, leap_year)
		@leap_year = leap_year
		@desired_state_of_residency = desired_state_of_residency
		
		{
			total_days_per_state: total_days_per_state,
			residency_conclusion: residency_conclusion,
			min_days_to_be_resident: @min_days_to_be_resident,
			max_days_left_in_other_states: @max_days_left_in_other_states
		}
	end


	protected
		def set_total_days
			self.total_days = (self.end_date - self.start_date).to_i
		end

end