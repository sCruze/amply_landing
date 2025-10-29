class ApplicationMailer < ActionMailer::Base
  default from:        -> { %("#{ENV.fetch('MAIL_FROM_NAME', 'Amply')} <#{ENV.fetch('MAIL_FROM_ADDRESS')}>") }
  default reply_to:    -> { ENV.fetch('MAIL_REPLY_TO', ENV.fetch('MAIL_FROM_ADDRESS')) }
  default return_path: -> { ENV.fetch('MAIL_FROM_ADDRESS') }

  layout "mailer"

  before_action :inline_brand_assets

  private

    def inline_brand_assets
      attach_inline("shared/logos/amply-logo.png", cid: "amply-logo", mime: "image/png")
    end

    def attach_inline(rel_path, cid:, mime:)
      path = Rails.root.join("app/assets/images", rel_path)

      if File.file?(path)
        filename = File.basename(path)
        attachments.inline[filename] = File.binread(path)
        attachments[filename].content_type = mime
        attachments[filename].content_id = "<#{cid}>"
      end
    end

end
