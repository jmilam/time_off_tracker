class StatusChange < ApplicationRecord
	validates :start_change, :end_change, :date, presence: true
	belongs_to :time_off_request, dependent: :destroy
end
