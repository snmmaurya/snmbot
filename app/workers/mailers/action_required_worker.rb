class Mailers::ActionRequiredWorker
  include Sidekiq::Worker

  def perform message, options={}
    # TODO mailer implemantation
    # AlertMailer.action_required(message, options).deliver_now
  end
end