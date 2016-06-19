class UsersController < ApplicationController
  before_action :get_user, only: [:show, :edit, :update, 
    :correct_user, :destroy]
  before_action :logged_in_user, only: [:index, :edit, 
    :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  def index
    # raise params.inspect
    # @users = User.paginate(page: params[:page])
    @users = User.all
  end

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

  def delete
  end

  def destroy
    @user.destroy
    flash[:success] = "User Deleted!"
    redirect_to users_url
  end

 	private
  
   	def user_params
   		params.require(:user).permit(
   			:username, :email, 
   			:password, :password_confirmation, 
   			:name, :birthday, :description, 
   			:image, :remove_image, 
   			:organisation, :position
  		)
  	end

    def get_user
      @user = User.find(params[:id])
    end

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please login."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      redirect_to(root_url) unless @user == current_user
    end

    def same_user
      correct_user
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
