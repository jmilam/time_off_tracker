class Manager < ApplicationRecord
	belongs_to :department, dependent: :destroy
	has_many :time_off_requests
end
