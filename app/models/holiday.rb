class Holiday < ApplicationRecord
	validates :name, :date, presence: true, uniqueness: true
end
