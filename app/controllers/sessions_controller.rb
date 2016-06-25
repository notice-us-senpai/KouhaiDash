class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(username: params[:session][:username])
    if user && user.authenticate(params[:session][:password])
      reset_session
      log_in user
      params[:session][:remember_me] == '1' ?
        remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = 'Invalid username or password'
      render 'new'
    end
  end

  def destroy
    reset_session
    log_out if logged_in?
    redirect_to root_url
	end

  def auth_callback
    auth = request.env['omniauth.auth']
    if logged_in?
    else
      #not logged in yet
      email = auth['info']['email'].downcase
      credentials = auth['credentials']
      google_account=GoogleAccount.find_by(gmail: email)
      if google_account
        #associated with existing google_account, update tokens, log in user if it exists
        update_tokens(google_account,credentials)
        user = User.find_by(id: google_account.user_id)
        if user
          #user exists
          log_in user
          redirect_back_or user
        else
          #invalid user, render register_with_google
          render_register(google_account)
        end
      elsif user=User.find_by(email: email)
        if user.google_account
          #user already has an existing google_account with another gmail address, flash error msg
          #revoke access for user
          revoke_google_token(credentials['token'])
          flash[:notice] = 'The Google email is already associated with another user. Please login with that account or another google account.'
          redirect_to root_path
        else
          #create google_account, log in user
          google_account=GoogleAccount.create(user_id: user.id, gmail: email)
          update_tokens(google_account,credentials)
          log_in user
          redirect_back_or user
        end
      else
        #create google_account with user_id: -1, render register_with_google
        google_account= GoogleAccount.create(user_id: -1, gmail: email)
        update_tokens(google_account,credentials)
        render_register(google_account)
      end
    end
  end

  def register_with_google
    @user = User.new(user_params)
    gacc_params=params.require(:gacc).permit(:id, :access_token)
    @google_id = gacc_params.fetch(:id, 0)
    @token = gacc_params.fetch(:access_token, 0)

    google_account=GoogleAccount.find_by(gacc_params)
    if @user.save && google_account && google_account.user_id == -1
      google_account.update_attributes(user_id: @user.id)
      google_account.refresh!
      log_in @user
      remember @user
    	flash[:success] = "Welcome to KouhaiDash!"
      redirect_to @user
    else
      render 'register_with_google'
    end
  end

  private
    def revoke_google_token(access_token)
      require 'net/http'
      uri = URI('https://accounts.google.com/o/oauth2/revoke')
      params = { :token => auth_client.access_token }
      uri.query = URI.encode_www_form(params)
      response = Net::HTTP.get_response(uri)
      if response.code == '200'
        #access is revoked
        return true
      else
        #an error has occurred
        return false
      end
    end
    def update_tokens(google_account, credentials)
      google_account.update_attributes(access_token: credentials['token'], expires_at: Time.at(credentials['expires_at']).to_datetime)
      if credentials['refresh_token']
        google_account.update_attributes(refresh_token: credentials['refresh_token'])
      end
    end
    def render_register(google_account)
      @user = User.new
      @user.email = google_account.gmail
      @google_id = google_account.id
      @token = google_account.access_token
      # update access_token without storing
      google_account.request_token_from_google
      render 'register_with_google'
    end
    def user_params
      params.require(:user).permit(
        :username, :email,
        :password, :password_confirmation,
        :name, :birthday, :description,
        :image, :remove_image,
        :organisation, :position
      )
    end
end
