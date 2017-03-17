class Department < ApplicationRecord
	validates :name, uniqueness: true, presence: true
	has_many :managers
	has_many :users
end
