Fabricator(:trip) do
	person
	start_date Today.date 
	end_date { Today.date - 45 }
	state { %w(CA FL GA IL).sample }	
end