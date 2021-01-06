require "active_support/concern"
module ErrorActions
  extend ActiveSupport::Concern

  def error_json(exception)
    {
      type:       'error',
      status:     Rack::Utils.status_code(exception.status),
      code:       exception.code,
      message:    exception.message,
      errors:     exception.errors,
      info:       exception.info
    }.to_json
  end

  def render_error(exception, status)
    render json: error_json(exception), status: exception.status
  end
end
