class Patient < ApplicationRecord
  validates :email, :first_name, :last_name, :birthdate, :sex, presence: true
  validates :email, uniqueness: { case_sensitive: false }
end
