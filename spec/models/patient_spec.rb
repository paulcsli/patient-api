require "rails_helper"

RSpec.describe Patient, :type => :model do
  describe "requires all attributes to be present upon saving to database" do
    let(:duplicate_email) { "Email has already been taken" }
    let(:invalid_email) { "Email is invalid" }
    let(:invalid_first_name) { "First name is invalid" }
    let(:invalid_last_name) { "Last name is invalid" }
    let(:invalid_sex) { "Sex must be either M or F" }
    let(:invalid_birthdate) { "Birthdate must be a valid datetime" }
    let(:blank_birthdate) { "Birthdate can't be blank" }

    it "throws exception due to missing attributes" do
      expect {
        Patient.create!
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "ignore case differences in email" do
      attrs = {
        :email => "randf@gmail.com",
        :first_name => "paul",
        :last_name => "li",
        :birthdate => "2011-03-29",
        :sex => "M",
      }
      Patient.create!(attrs)
      expect(Patient.count).to be == 1

      p = Patient.create(attrs.merge({ :email => "RANDF@gmail.com" }))
      expect(p.errors.full_messages).to include(duplicate_email)
    end

    it "reports error due to invalid chars in first_name and last_name" do
      attrs = {
        :email=>"invalidemails",
        :first_name=>"!paul",
        :last_name=>"li?",
        :birthdate=>"000000",
        :sex=>"male",
      }
      p = Patient.create(attrs)
      expect(p.errors.full_messages).to include(
        invalid_first_name,
        invalid_last_name,
        invalid_sex,
        invalid_email,
        invalid_birthdate,
        blank_birthdate
      )
    end
  end
end
