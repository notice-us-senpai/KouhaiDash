class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
    if @user.save
    	flash[:success] = "Welcome to KouhaiDash!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
  	@user = User.find(params[:id])
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
end
