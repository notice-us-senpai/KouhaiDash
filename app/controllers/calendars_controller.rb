class CalendarsController < ApplicationController
  before_action :set_variables
  before_action :check_view_auth
  before_action :check_edit_auth, only: [:edit, :update, :destroy, :new, :create]
  before_action :check_created, only:[:new, :create]
  before_action :google_access_for_edit, only: [:edit, :update, :new, :create]

  # GET /calendars/1
  # GET /calendars/1.json
  def show
    unless @calendar
      redirect_to new_group_category_calendar_path(@group,@category)
      return
    end
    get_events(Time.now.in_time_zone(@calendar.time_zone).to_datetime)
    flash.now[:google_msg]=@google_msg if @google_msg
  end

  # POST /calendar/show_period
  def show_period
    respond_to do |format|
      format.js{
        period_params=params.require(:period).permit(:month, :year)
        get_events(Date.new(period_params[:year].to_i, period_params[:month].to_i,1))
      }
    end
  end

  # GET /calendars/new
  def new
    @calendar = Calendar.new
  end

  # GET /calendars/1/edit
  def edit
  end

  # POST /calendars
  # POST /calendars.json
  def create
    @calendar = Calendar.new(calendar_params)
    @calendar.category = @category
    check_google_calendar
    respond_to do |format|
      if @calendar.save
        google_settings
        format.html {
          if @new_cal
            if @created
              flash[:google_notice]='New Google Calendar was successfully created.'
            else
              flash[:google_notice]='There was an issue with creating the new Google Calendar.'
            end
          end
          flash[:google_settings]='Attempt to change ACL for Google Calendar failed.' if @settings_failed
          flash[:notice]='Calendar was successfully created.'
          redirect_to group_category_calendar_path(@group,@category)
        }
        format.json { render :show, status: :created, location: group_category_calendar_path(@group,@category) }
      else
        format.html {
          if @new_cal
            if @created
              flash.now[:google_notice]='New Google Calendar was successfully created.'
            else
              flash.now[:google_notice]='There was an issue with creating the new Google Calendar.'
            end
          end
          render :new
        }
        format.json { render json: @calendar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calendars/1
  # PATCH/PUT /calendars/1.json
  def update
    check_google_calendar
    respond_to do |format|
      if @calendar.update(calendar_params)
        google_settings
        format.html {
          if @new_cal
            if @created
              flash[:google_notice]='New Google Calendar was successfully created.'
            else
              flash[:google_notice]='There was an issue with creating the new Google Calendar.'
            end
          end
          flash[:google_settings]='Attempt to change ACL for Google Calendar failed.' if @settings_failed
          flash[:notice]='Calendar was successfully updated.'
          redirect_to group_category_calendar_path(@group,@category)
        }
        format.json { render :show, status: :ok, location: group_category_calendar_path(@group,@category) }
      else
        format.html {
          if @new_cal
            if @created
              flash.now[:google_notice]='New Google Calendar was successfully created.'
            else
              flash.now[:google_notice]='There was an issue with creating the new Google Calendar.'
            end
          end
          render :edit }
        format.json { render json: @calendar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calendars/1
  # DELETE /calendars/1.json
  def destroy
    @calendar.destroy
    respond_to do |format|
      format.html { redirect_to @group,@category, notice: 'Calendar was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def to_authenticate
    store_location_url(
      if @calendar
        edit_group_category_calendar_path(@group,@category)
      else
        new_group_category_calendar_path(@group,@category)
      end)
    redirect_to '/auth/google_oauth2'
  end

  private
    def get_events(date)

      day_start=DateTime.new(date.year,date.month,1,0,0, 0, ActiveSupport::TimeZone[@calendar.time_zone].formatted_offset)
      day_end=DateTime.new(date.year,date.month,1,23,59,59, ActiveSupport::TimeZone[@calendar.time_zone].formatted_offset)
      month_start = DateTime.new(date.year,date.month,1,0,0, 0, ActiveSupport::TimeZone[@calendar.time_zone].formatted_offset)
      month_end = DateTime.new(date.next_month.year,date.next_month.month,1,0,0, 0, ActiveSupport::TimeZone[@calendar.time_zone].formatted_offset)
      @start=day_start.cwday%7
      @days_in_month=Time.days_in_month(date.month,date.year)
      @day_events=Array.new(@days_in_month,nil)
      @google_events=[]
      @events= @calendar.events.where.not('"start" >= ?', month_end).where.not('"end" < ?', month_start).order(:start).to_a
      @events.shift while !@events.empty? && @events.first.start<month_start
      if @calendar.google_calendar_id && @calendar.google_calendar_id.length>0
        #load google calendar events
        begin
          token = (current_user && current_user.google_account && current_user.google_account.fresh_token) || @calendar.google_account.fresh_token
          calendar_client = Signet::OAuth2::Client.new(access_token: token)
          calendar_service = Google::Apis::CalendarV3::CalendarService.new
          calendar_service.authorization = calendar_client
          result= calendar_service.list_events(@calendar.google_calendar_id, single_events: true,
            order_by: "startTime",time_max: month_end.rfc3339,
            time_min: month_start.rfc3339)
          @google_events=result.items
        rescue
          #tries reset google calendar settings
          google_settings
          begin
            token = (current_user && current_user.google_account && current_user.google_account.fresh_token) || @calendar.google_account.fresh_token
            calendar_client = Signet::OAuth2::Client.new(access_token: token)
            calendar_service = Google::Apis::CalendarV3::CalendarService.new
            calendar_service.authorization = calendar_client
            result= calendar_service.list_events(@calendar.google_calendar_id, single_events: true,
              order_by: "startTime",time_max: month_end.rfc3339,
              time_min: month_start.rfc3339)
            @google_events=result.items
          rescue
            @google_msg='There was an issue loading events from the Google Calendar.'
          end
        end
      end

      gIdx=0
      eIdx=0
      for i in (0..@days_in_month-1)
        @day_events[i]=[]
        if gIdx<@google_events.length
          gIdx+=1 while gIdx< @google_events.length && @google_events[gIdx].end.date_time<day_start
          idx=gIdx
          while idx<@google_events.length && @google_events[idx].start.date_time<=day_end
            @day_events[i].push({event:@google_events[idx],id:idx, google:true}) if @google_events[idx].end.date_time>day_start || @google_events[idx].start.date_time==day_start
            idx+=1
          end
        end
        if eIdx<@events.length
          eIdx+=1 while eIdx< @events.length && @events[eIdx].end<day_start
          idx=eIdx
          while idx<@events.length && @events[idx].start<=day_end
            @day_events[i].push({event:@events[idx],id:idx, google:false}) if @events[idx].end>day_start || @events[idx].start==day_start
            idx+=1
          end
        end
        day_start=day_start.next_day
        day_end=day_end.next_day
      end
    end

    def check_google_calendar
      if params.fetch(:gradio,false)
        opt=params.fetch(:gradio)
        case opt
        when "current"
          @calendar.google_account_id=current_user.google_account.id
        when "no"
          @calendar.google_calendar_id = nil
        when "select"
          if params.fetch(:google,false)
            @calendar.google_calendar_id=params.fetch(:google).fetch(:calendar_id,@calendar.google_calendar_id)
            @calendar.google_account_id=current_user.google_account.id
          end
        when "new"
          @new_cal=true
          if params.fetch(:google,false)
            begin
              calendar_client = Signet::OAuth2::Client.new(access_token: @google_token)
              calendar_service = Google::Apis::CalendarV3::CalendarService.new
              calendar_service.authorization = calendar_client
              cal_name = params.fetch(:google).fetch(:name,@calendar.name)
              cal_name = @category.name unless cal_name && cal_name.length>0
              calendar =  Google::Apis::CalendarV3::Calendar.new(summary: cal_name)
              result = calendar_service.insert_calendar(calendar)
              @calendar.google_calendar_id=result.id
              @created=result.id
              result = calendar_service.list_calendar_lists(min_access_role: "owner")
              @calendar_array=result.items.collect{|cal| [cal.summary, cal.id]}
              @calendar.google_account_id=current_user.google_account.id
            rescue
            end
          end
        end
      end
    end

    def google_settings
      if @calendar.google_calendar_id && @calendar.google_calendar_id.length>0
        calendar_service = Google::Apis::CalendarV3::CalendarService.new
        group= Group.includes(memberships:{user: :google_account}).find(@group.id)
        accounts=group.memberships.collect{|member|
          {account: member.user.google_account, is_owner: false} if member.approved && member.user.google_account
        }
        #try to find an owner account
        begin
          #find using stored google_account
          calendar_client = Signet::OAuth2::Client.new(access_token: @calendar.google_account.fresh_token)
          calendar_service.authorization = calendar_client
          result=calendar_service.get_calendar_list(@calendar.google_calendar_id)
          @owner_found=(result.access_role=='owner')
        rescue Exception => e
          #puts e.message
          #find within members' accounts
          accounts.each do |item|
            break if @owner_found
            next unless item
            token=item[:account].fresh_token
            begin
              calendar_client = Signet::OAuth2::Client.new(access_token: token)
              calendar_service.authorization=calendar_client
              result=calendar_service.get_calendar_list(@calendar.google_calendar_id)
              @owner_found=item[:is_owner]=(result.access_role=='owner')
              @calendar.update_attributes(google_account_id: item[:account].id) if @owner_found
            rescue
            end
          end
        end
        #return if no owner is found
        @settings_failed = true unless @owner_found
        return unless @owner_found
        #add ACL rules

        calendar_client = Signet::OAuth2::Client.new(access_token: @calendar.google_account.fresh_token)
        calendar_service.authorization = calendar_client

        #time_zone
        begin
          result=calendar_service.get_calendar(@calendar.google_calendar_id)
          result.time_zone=ActiveSupport::TimeZone[@calendar.time_zone].tzinfo.identifier
          result=calendar_service.update_calendar(@calendar.google_calendar_id,result)
        rescue Exception => e
          puts e.message
          @settings_failed=true
        end

        # public read access
        begin
          rule = Google::Apis::CalendarV3::AclRule.new(
            scope: {
              type: 'default'
            },
            role: 'reader'
          )
          result=calendar_service.insert_acl(@calendar.google_calendar_id, rule)
        rescue Exception => e
          #puts e.message
          @settings_failed=true
        end
        #add individual member
        accounts.each do |item|
          next unless item
          next if item[:is_owner]
          next if item[:account].id==@calendar.google_account_id
          begin
            rule = Google::Apis::CalendarV3::AclRule.new(
              scope: {
                type: 'user',
                value: item[:account].gmail
              },
              role: 'owner'
            )
            result=calendar_service.insert_acl(@calendar.google_calendar_id, rule)
          rescue Exception => e
            #puts e.message
            @settings_failed=true
          end
        end
      end
    end

    def set_variables
      @group = Group.find(params[:group_id])
      @category = @group.categories.find(params[:category_id])
      @calendar = @category.calendar
      @authorised_member= is_user_of_group?(@group)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def calendar_params
      params.require(:calendar).permit(:name, :google_calendar_id, :time_zone)
    end

    def check_edit_auth
      unless @authorised_member
        category_edit_auth_redirect(@group,@category)
      end
    end

    def check_view_auth
      if @category.type_no!=0
        flash[:notice]='Did you lost your way?'
        redirect_to @group
      end
      unless @authorised_member
        check_category_view_auth(@group,@category)
      end
    end

    def check_created
      if @calendar
        redirect_to group_category_calendar_path(@group,@category)
        return
      end
    end

    def google_access_for_edit
      account = current_user.google_account
      @calendar_array=[];
      if account
        account.refresh!
        unless account.refresh_token.length>0
          revoke_google_token(account.access_token)
          flash.now[:notice] = 'Permissions from your google account has expired. Please sign in with google again to renew the permissions.'
        end
        @google_token = account && account.refresh_token.length>0 && account.fresh_token
        if @google_token
          begin
            calendar_client = Signet::OAuth2::Client.new(access_token: @google_token)
            calendar_service = Google::Apis::CalendarV3::CalendarService.new
            calendar_service.authorization = calendar_client
            result = calendar_service.list_calendar_lists(min_access_role: "owner")
            @calendar_array=result.items.collect{|cal| [cal.summary, cal.id]}
            result= calendar_service.get_calendar(@calendar.google_calendar_id)
            @google_calendar_name=result.summary
          rescue
          end
        end
      #google_token, @google_id is nill if refresh fails ( ie access has failed and fresh_token = '')
      end
    end
end
