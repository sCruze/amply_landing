# app/mailers/application_mailer.rb
class ApplicationMailer < ActionMailer::Base
  layout "mailer"
  before_action :inline_brand_assets

  default from: -> {
    email = (ENV["MAIL_FROM_ADDRESS"].presence || ENV["SMTP_USER_NAME"].presence || "noreply@example.invalid")
    name  = (ENV["MAIL_FROM_NAME"].presence    || "Amply")
    "#{name} <#{email}>"
  }

  default reply_to:    -> { ENV["MAIL_REPLY_TO"].presence    || ENV["MAIL_FROM_ADDRESS"].presence || ENV["SMTP_USER_NAME"] }
  default return_path: -> { ENV["SMTP_USER_NAME"].presence    || ENV["MAIL_FROM_ADDRESS"].presence || "noreply@example.invalid" }

  private

    def inline_brand_assets
      attach_inline("shared/logos/amply-logo.png", cid: "amply-logo", mime: "image/png")
    end

    def attach_inline(rel_path, cid:, mime:)
      path = Rails.root.join("app/assets/images", rel_path)
      return unless File.file?(path)

      filename = File.basename(path)
      attachments.inline[filename] = File.binread(path)
      attachments[filename].content_type = mime
      attachments[filename].content_id   = "<#{cid}>"
    end
end
