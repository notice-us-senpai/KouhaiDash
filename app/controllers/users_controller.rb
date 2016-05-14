class UsersController < ApplicationController
  before_action :get_user, only: [:show, :edit, :update]
  before_action :logged_in_user, only: [:edit, :update]
  
  def show
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
    if @user.save
      log_in @user
      remember @user
    	flash[:success] = "Welcome to KouhaiDash!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile Updated!"
      redirect_to @user
    else
      render 'edit'
    end
  end

 	private
  
   	def user_params
   		params.require(:user).permit(
   			:username, :email, 
   			:password, :password_confirmation, 
   			:name, :birthday, :description, 
   			:picture, 
   			:organisation, :position
  		)
  	end

    def get_user
      @user = User.find(params[:id])
    end

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please login."
        redirect_to login_url
      end
    end
end
