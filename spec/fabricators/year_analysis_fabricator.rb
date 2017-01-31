Fabricator(:year_analysis) do 
	# desired_state_of_residency { %w(CA FL GA IL).sample }
	desired_state_of_residency { "CA" }
	year { %w(1997 1999 2011).sample }
end
