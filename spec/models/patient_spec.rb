require "rails_helper"

RSpec.describe Patient, :type => :model do
  describe "requires all attributes to be present upon saving to database" do
    let(:duplicate_email) { "Email has already been taken" }
    let(:invalid_email) { "Email is invalid" }
    let(:invalid_first_name) { "First name is invalid" }
    let(:invalid_last_name) { "Last name is invalid" }
    let(:invalid_sex) { "Sex must be either M or F" }

    it "throws exception due to missing attributes" do
      expect {
        Patient.create!
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "reports error due to invalid chars in first_name and last_name" do
      attrs = {
        :email=>"invalidemails",
        :first_name=>"!paul",
        :last_name=>"li?",
        :birthdate=>"2011-03-29",
        :sex=>"male",
      }
      p = Patient.create(attrs)
      expect(p.errors.full_messages).to include(invalid_first_name, invalid_last_name, invalid_sex, invalid_email)
    end
  end
end
