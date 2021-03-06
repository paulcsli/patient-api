class Patient < ApplicationRecord
  validates :email, :first_name, :last_name, :birthdate, :sex, presence: true

  validates :email, uniqueness: { case_sensitive: false }, format: { with: /\A.+@.+\z/ }

  validates_format_of :first_name, :with => /\A[^0-9`!?@#\$%\^&*+_=]+\z/
  validates_format_of :last_name, :with => /\A[^0-9`!?@#\$%\^&*+_=]+\z/

  validate :birthdate_is_valid_datetime

  validates :sex, inclusion: {
    :in => %w(M F),
    :message => "must be either M or F" }

  scope :get_one_page, ->(page_size, page_index) {
    limit(page_size).offset(page_index * page_size)
  }

  def birthdate_is_valid_datetime
    errors.add(:birthdate, 'must be a valid datetime') if birthdate.nil?
  end

  def format_error_msgs
    errors.full_messages.join("; ")
  end

  def error_type
    if errors[:email].include?("has already been taken")
      :duplicate_email
    else
      :bad_format
    end
  end

  def select_attributes
    {
      :id => id.to_s,
      :email => email,
      :first_name => first_name,
      :last_name => last_name,
      :birthdate => birthdate.to_s,
      :sex => sex,
    }
  end

  def generate_patient_link(base_url)
    "#{base_url}/v1/patients/#{id}"
  end

  def generate_patient_response(base_url)
    {
      :link => generate_patient_link(base_url),
      :type => "Patient",
      :attributes => select_attributes(),
    }
  end
end
