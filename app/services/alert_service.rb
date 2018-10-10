class AlertService

  def initialize options
    @options = options
  end

  def action_required message, options={}
    Mailers::ActionRequiredWorker.perform_async(message, options)
  end

  private
    attr_reader :options
end