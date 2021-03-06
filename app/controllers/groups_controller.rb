class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy, :join]
  before_action :set_auth, only:[:show, :edit, :update, :destroy]
  before_action :check_edit_auth, only: [:edit, :update, :destroy]
  before_action :check_logged_in, only:[:new, :create, :join]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.limit(10).all
  end

  def show_by_string_id
    @group=Group.find_by(string_id: params[:string_id].downcase)
    if @group
      redirect_to @group
    else
      redirect_to groups_path
    end
  end

  def search
    @groups = Group.where('LOWER(name) LIKE ?',"%#{params.require(:search)[:input]}%".downcase).order("LENGTH(name) ASC").limit(10)
    respond_to do |format|
      format.js{}
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    if @authorised_member
      @categories=@group.categories
      @members=@group.memberships
      @unapproved=@members.where(approved:false)
      @overdue=@group.tasks.where(done: false).where("deadline < ?",Date.today).order('deadline ASC').limit(5)
      @tasks=@group.tasks.where(done: false).where("deadline >= ?",Date.today).order("deadline ASC").limit(5)
      @events=@group.events.includes(:calendar).where('"end" >= ?',Time.now).order("start").where('"start" < ?',Time.now + 7.days).order("start ASC").limit(5).collect{|event|
        {start:event.start, google:false, event:event, category: event.calendar.category_id, time_zone: event.calendar.time_zone}}
      @group.calendars.each do |cal|
        next unless cal.google_calendar_id && cal.google_calendar_id.length>0
        begin
          token = cal.google_account.fresh_token
          calendar_client = Signet::OAuth2::Client.new(access_token: token)
          calendar_service = Google::Apis::CalendarV3::CalendarService.new
          calendar_service.authorization = calendar_client
          result= calendar_service.list_events(cal.google_calendar_id, single_events: true, max_results: 5,
            order_by: "startTime",time_max: (Time.now + 7.days).to_datetime.rfc3339,
            time_min: Time.now.to_datetime.rfc3339)
          @events.concat(result.items.collect{|event|{start: event.start.date_time,google: true, event:event, category: cal.category_id, time_zone:cal.time_zone}})
        rescue
        end
      end
      @events.sort!{
        |x,y| x[:start]<=>y[:start]
      }
      @events=@events.first(5)
      @text_pages=@group.text_pages
    end
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        @group.memberships.create(user_id: current_user.id, approved: true)
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /join_group/1
  def join
    @membership=@group.memberships.new(user_id: current_user.id, approved: false)
    if @membership.save
      flash[:notice] = "The request has been sent."
      redirect_to @group
    else
      flash[:error] = @membership.errors.full_messages
      redirect_to groups_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    def set_auth
      @authorised_member= is_user_of_group?(@group)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :members_public,:description,:string_id)
    end

    #checks if user if a member of the group
    def check_edit_auth
      unless logged_in?
        flash[:notice] = 'Log in as a member of the group.'
        redirect_to login_url
        return
      end
      unless @authorised_member
        flash[:notice] = 'Join the group and wait for your request to be accepted!'
        redirect_to groups_path
        return
      end
    end

    def check_logged_in
      unless logged_in?
        flash[:notice] = 'Please log in first.'
        redirect_to login_url
      end
    end
end
