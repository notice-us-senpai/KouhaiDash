module SessionsHelper
	# Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
    # session[:group_id] = User.find(user.id).groups.first.id
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end

	# Returns the current logged-in user (if any).
  # def current_user
  	# @current_user ||= User.find_by(id: session[:user_id])
	# end

  # Returns the user corresponding to the remember token cookie.
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

  def current_group
    if current_user
# <<<<<<< HEAD
      # @current_group = Group.where(id:session[:group_id]).first
# =======
      # @current_group = Group.where(id:session[:group_id]).first
# >>>>>>> delete-user
    end
  end

  def change_group(group)
# <<<<<<< HEAD
    # session[:group_id] = group.id
# =======
    # session[:group_id] = group.id
# >>>>>>> delete-user
  end

	# Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end
