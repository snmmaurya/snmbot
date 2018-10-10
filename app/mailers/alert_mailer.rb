class AlertMailer < ActionMailer::Base

  def action_required message, options={}
    @message, @options = message, options
    mail(to: "snmmaurya@gmail.com", subject: "#{Rails.env.titleize} Action Required", content_type: "text/html")
  end

end