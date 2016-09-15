class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper

  before_action :require_login


  private

    def require_login
      unless logged_in
        store_location
        flash[:warning] = 'Please log in.'
        redirect_to login_url
      end
    end

    def require_admin
      unless current_user.admin?
        redirect_back_or_default(default: root_url, flash: { danger: 'That was not the best place to be in (access denied).' })
      end
    end

end
