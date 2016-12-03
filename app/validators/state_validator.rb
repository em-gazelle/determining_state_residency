class StateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
  	unless STATES.map{ |state, abbreviation| abbreviation }.include?(value)
		record.errors[attribute] << (options[:message] || "You must write your state or 'NA' for time spent outside of the US")
	end
  end
end