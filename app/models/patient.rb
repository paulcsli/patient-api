class Patient < ApplicationRecord
  validates :email, :first_name, :last_name, :birthdate, :sex, presence: true
  validates :email, uniqueness: true
end
