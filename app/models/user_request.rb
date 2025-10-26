class UserRequest < ApplicationRecord

  validates :name,  presence: true, length: { maximum: 30 }
  validates :email, presence: true,
            length: { maximum: 100 },
            format:  { with: URI::MailTo::EMAIL_REGEXP }

end
