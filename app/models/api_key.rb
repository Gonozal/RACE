class ApiKey < ActiveRecord::Base
	has_many :characters
	has_many :corporations
end
