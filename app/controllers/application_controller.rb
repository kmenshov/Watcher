class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper

  before_action :require_login


  private

    def redirect_back_or_default(default: root_url, **options)
      redirect_to (request.referer.present? ? :back : default), options
    end

    def require_login
      unless logged_in
        flash[:alert] = 'Please log in.'
        redirect_to login_url
      end
    end

end
