class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionController::RequestForgeryProtection
  include Errors
  include ErrorActions

  before_action :prevent_page_caching

  HTTPResponseErrors.each do |code, status|
    class_eval <<-EOS
      rescue_from(#{code.to_s.camelize}) {|e| render_error e }
    EOS
  end

  private 

  def prevent_page_caching
    response.headers['Cache-Control']   = 'no-store'
    response.headers['Pragma']          = 'no-cache'
    response.headers['Expires']         = '0'
    response.headers['X-Frame-Options'] = 'DENY'
  end

end
