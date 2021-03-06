module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    current_user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
    session.delete(:user_id)
    @current_user = nil
  end

  def remember(user)
    return if (user.id == cookies.signed[:user_id]) && user.authenticated?(cookies[:remember_token])
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  alias logged_in current_user

  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

  def redirect_session_or_default(default: root_url, **options)
    redirect_to (session[:forwarding_url] || default), options
    session.delete(:forwarding_url)
  end

  def redirect_back_or_default(default: root_url, **options)
    redirect_to (request.referer.present? ? :back : default), options
  end

end
