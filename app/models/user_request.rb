class UserRequest < ApplicationRecord

  validates :name,  presence: true, length: { maximum: 30 }
  validates :email, presence: true,
            length: { maximum: 100 },
            format:  { with: URI::MailTo::EMAIL_REGEXP }

  after_commit :send_emails_now, on: :create

  private

    def send_emails_now
      UserRequestMailer.confirmation(self).deliver_now
      UserRequestMailer.team_digest(self).deliver_now
    end

end
