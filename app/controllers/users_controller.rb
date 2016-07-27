class UsersController < ApplicationController
  before_action :get_user, only: [:show, :edit, :update,
    :correct_user, :destroy, :to_authenticate, :to_revoke]
  before_action :logged_in_user, only: [:index, :edit,
    :update]
  before_action :correct_user, only: [:edit, :update, :to_authenticate, :to_revoke]
  before_action :admin_user, only: :destroy
  before_action :set_google_account, only: [:edit, :update]

  def index
    # raise params.inspect
    # @users = User.paginate(page: params[:page])
    @users = User.all
  end

  def show
    @memberships=@user.memberships.includes(:group).order(:approved)
    if @user==current_user
      @overdue=@user.tasks.includes(:category).where(done: false).where("deadline < ?",Date.today).order('deadline ASC').limit(5)
      @tasks=@user.tasks.includes(:category).where(done: false).where("deadline >= ?",Date.today).order("deadline ASC").limit(5)
      @events=@user.events.includes(calendar: {category: :group}).where('"end" >= ?',Time.now).order("start").where('"start" < ?',Time.now + 7.days).order("start ASC").limit(5).collect{|event|
        {start:event.start, google:false, event:event, category: event.calendar.category_id, time_zone: event.calendar.time_zone , group: event.calendar.category.group.id}}
      @user.calendars.each do |cal|
        next unless cal.google_calendar_id && cal.google_calendar_id.length>0
        begin
          token = cal.google_account.fresh_token
          calendar_client = Signet::OAuth2::Client.new(access_token: token)
          calendar_service = Google::Apis::CalendarV3::CalendarService.new
          calendar_service.authorization = calendar_client
          result= calendar_service.list_events(cal.google_calendar_id, single_events: true, max_results: 5,
            order_by: "startTime",time_max: (Time.now + 7.days).to_datetime.rfc3339,
            time_min: Time.now.to_datetime.rfc3339)
          @events.concat(result.items.collect{|event|{start: event.start.date_time,google: true, event:event, category: cal.category_id, time_zone:cal.time_zone, group: cal.category.group.id}})
        rescue
        end
      end
      @events.sort!{
        |x,y| x[:start]<=>y[:start]
      }
      @events=@events.first(5)
    end
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

  def to_authenticate
    store_location_url(edit_user_path(@user))
    redirect_to '/auth/google_oauth2'
  end

  def to_revoke
    if revoke_google_token(@user.google_account.fresh_token)
      flash[:notice] = 'The google account is no longer associated with your account. Permissions for KouhaiDash are also revoked.'
    end
    @user.google_account.destroy
    redirect_to edit_user_path(@user)
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
      # raise params.inspect
      @user = User.find_by_username(params[:id])
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

    def set_google_account
      @google_account=@user.google_account
      if @google_account
        @google_account.refresh!
        unless @google_account.refresh_token.length>0
          @revoked = true
          revoke_google_token(@google_account.access_token)
          flash.now[:notice] = 'Permissions from your google account has expired. Please sign in with google again to renew the permissions.'
        end
      end
    end
end
