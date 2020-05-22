class Patient < ApplicationRecord
  validates :email, :first_name, :last_name, :birthdate, :sex, presence: true
  validates :email, uniqueness: { case_sensitive: false }

  def format_error_msgs
    details = []
    @errors.messages.each do |attribute, msgs|
      msgs.each do |msg|
        details << "#{attribute} #{msg};"
      end
    end
    details.join(' ')
  end

  def error_type
    if @errors[:email].include?("has already been taken")
      :duplicate_email
    else
      :bad_format
    end
  end
end
