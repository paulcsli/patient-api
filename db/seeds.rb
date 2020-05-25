# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'date'
require 'securerandom'

def random_email_generator
  "#{SecureRandom.hex}@gmail.com"
end

def random_birthday_generator
  year, month, day = rand(1900..2000), rand(1..12), rand(1..28)
  DateTime.new(year, month, day)
end

def random_name_generator
  ltrs = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
  string = (1...15).map { ltrs[rand(ltrs.length)] }.join
end

for i in 1..100 do
  attributes = {
    email: "#{random_email_generator()}",
    first_name: "#{random_name_generator()}",
    last_name: "#{random_name_generator()}",
    birthdate: "#{random_birthday_generator()}",
    sex: ["M", "F"].sample,
  }
  patient = Patient.create!(attributes)
end
