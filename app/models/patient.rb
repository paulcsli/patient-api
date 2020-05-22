class Patient < ApplicationRecord
  validates :email, :first_name, :last_name, :birthdate, :sex, presence: true

  validates :email, uniqueness: { case_sensitive: false }, format: { with: /\A.+@.+\z/ }

  validates_format_of :first_name, :with => /\A[^0-9`!?@#\$%\^&*+_=]+\z/
  validates_format_of :last_name, :with => /\A[^0-9`!?@#\$%\^&*+_=]+\z/

  validates :sex, inclusion: {
    :in => %w(M F),
    :message => "must be either M or F" }

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
end
