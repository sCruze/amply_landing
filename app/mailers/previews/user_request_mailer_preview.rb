# frozen_string_literal: true

class UserRequestMailerPreview < ActionMailer::Preview
  def confirmation
    ur = UserRequest.last || UserRequest.new(id: 1, name: "Alex", email: "alex@example.com", created_at: Time.current)
    UserRequestMailer.confirmation(ur.id)
  end

  def team_digest
    ur = UserRequest.last || UserRequest.new(id: 1, name: "Alex", email: "alex@example.com", created_at: Time.current)
    UserRequestMailer.team_digest(ur.id, recipients: %w[founder@example.com team@example.com])
  end
end
