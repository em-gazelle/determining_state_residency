Fabricator(:trip) do
	start_date Date.today 
	end_date { Date.today - 45 }
	state { %w(CA FL GA IL).sample }	
end
