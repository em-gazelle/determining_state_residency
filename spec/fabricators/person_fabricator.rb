Fabricator(:person) do 
	# desired_state_of_residency { %w(CA FL GA IL).sample }
	desired_state_of_residency { "CA" }
	year { %w(2016 2000 1999 2011).sample }
end
