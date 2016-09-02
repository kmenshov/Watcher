class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper


  private

    def redirect_back_or_default(default = root_path, options = {})
      redirect_to (request.referer.present? ? :back : default), options
    end

end
