# frozen_string_literal: true

class UserRequestMailer < ApplicationMailer

  def confirmation(entity)
    @user_request = UserRequest.find(entity.id)

    mail(
      to:      @user_request.email,
      subject: "Thanks for joining the Amply waitlist ✨"
    )
  end

  def team_digest(entity.id, recipients: nil)
    @user_request = UserRequest.find(entity.id)

    @total_count  = UserRequest.count
    @weekly_count = UserRequest.where("created_at >= ?", 7.days.ago).count
    @recent       = UserRequest.order(created_at: :desc).limit(5)

    recipients ||= ENV.fetch("WAITLIST_NOTIFY_RECIPIENTS", "")
                      .split(/[,\s;]+/)
                      .reject(&:blank?)
                      .uniq

    fallback = ENV.fetch("MAIL_FALLBACK_TO", ENV.fetch("MAIL_FROM_ADDRESS", "noreply@your-domain"))
    to_list  = (recipients.presence || [fallback])

    mail(
      to:      to_list,
      subject: "New waitlist signup — #{ @user_request.name.presence || @user_request.email }"
    )
  end
end
