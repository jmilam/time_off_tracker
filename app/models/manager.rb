class Manager < ApplicationRecord
	belongs_to :department
	has_many :time_off_requests
end
