class Manager < ApplicationRecord
	validates :name, :department_id, :email, presence: true
	belongs_to :department, dependent: :destroy
	has_many :time_off_requests
end
