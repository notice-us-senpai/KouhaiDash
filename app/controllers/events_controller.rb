class EventsController < ApplicationController
  before_action :set_variables
  before_action :check_view_auth
  before_action :check_edit_auth, only: [:edit, :update, :destroy, :new, :create]
  before_action :check_created
  before_action :set_event, only: [:edit, :update, :show, :destroy]
  before_action :set_google_event, only:[:google_edit, :google_show, :google_update]

  # GET /events
  # GET /events.json
  def index
    @events = @calendar.events
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.calendar_id=@category.calendar.id
    @event.start &&= DateTime.new(@event.start.year, @event.start.month, @event.start.day,
      params[:start][:hour].to_i, params[:start][:min].to_i, 0, ActiveSupport::TimeZone[@calendar.time_zone].formatted_offset)
    @event.end &&= DateTime.new(@event.end.year, @event.end.month, @event.end.day,
      params[:end][:hour].to_i, params[:end][:min].to_i, 0, ActiveSupport::TimeZone[@calendar.time_zone].formatted_offset)
    respond_to do |format|
      if @event.save
        begin
          #create with google calendar and destroy if possible
          calendar_client = Signet::OAuth2::Client.new(access_token: current_user.google_account.fresh_token)
          calendar_service = Google::Apis::CalendarV3::CalendarService.new
          calendar_service.authorization = calendar_client
          event = Google::Apis::CalendarV3::Event.new(
            summary: @event.summary,
            location: @event.location,
            description: @event.description,
            start: {
              date_time: @event.start.rfc3339
            },
            end: {
              date_time: @event.end.rfc3339
            }
          )
          result = calendar_service.insert_event(@calendar.google_calendar_id, event)
          puts @event.start.rfc3339
          puts @event.end.rfc3339
          @event.destroy if result.id
        rescue Exception => e
          puts e.message
        end
        format.html { redirect_to [@group,@category,@event], notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: [@group,@category,@event] }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    update_params=event_params.to_h
    begin
      day= DateTime.parse(update_params['start'])
      update_params['start']= DateTime.new(day.year, day.month, day.day,
        params[:start][:hour].to_i, params[:start][:min].to_i, 0, ActiveSupport::TimeZone[@calendar.time_zone].formatted_offset)
    rescue
    end
    begin
    day= DateTime.parse(update_params['end'])
    update_params['end']= DateTime.new(day.year, day.month, day.day,
      params[:end][:hour].to_i, params[:end][:min].to_i, 0, ActiveSupport::TimeZone[@calendar.time_zone].formatted_offset)
    rescue
    end
    respond_to do |format|
      if @event.update(update_params)
        format.html { redirect_to [@group,@category,@event], notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: [@group,@category,@event] }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to group_category_events_path(@group,@category), notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def google_show
  end

  def google_edit
  end

  def google_update
    google_event_params=params.require(:google_event).permit(:summary, :location, :description, :start, :end)
    begin
      day= DateTime.parse(google_event_params['start'])
      google_event_params['start']= DateTime.new(day.year, day.month, day.day,
        params[:start][:hour].to_i, params[:start][:min].to_i, 0, ActiveSupport::TimeZone[@calendar.time_zone].formatted_offset)
    rescue
      @date_failed=true
    end
    begin
    day= DateTime.parse(google_event_params['end'])
    google_event_params['end']= DateTime.new(day.year, day.month, day.day,
      params[:end][:hour].to_i, params[:end][:min].to_i, 0, ActiveSupport::TimeZone[@calendar.time_zone].formatted_offset)
    rescue
      @date_failed=true
    end
    google_update_failed if @date_failed
    unless @date_failed
      begin
        @google_event.update!(summary: google_event_params['summary'],
          location: google_event_params['location'],
          description: google_event_params['description'],
        )
        @google_event.start = Google::Apis::CalendarV3::EventDateTime.new(time_zone: @calendar.time_zone,
          date_time: google_event_params['start'])
        @google_event.end = Google::Apis::CalendarV3::EventDateTime.new(time_zone: @calendar.time_zone,
          date_time: google_event_params['end'])
        calendar_client = Signet::OAuth2::Client.new(access_token: current_user.google_account.fresh_token)
        calendar_service = Google::Apis::CalendarV3::CalendarService.new
        calendar_service.authorization = calendar_client
        @google_event=calendar_service.update_event(@calendar.google_calendar_id, @google_event.id, @google_event)
        redirect_to group_category_calendar_path(@group,@category), notice: 'Google Event was successfully updated.'
      rescue Exception =>e
        puts e.message
        google_update_failed
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def google_update_failed
      flash.now[:notice]='Update was unsuccessful'
      render 'google_edit'

    end

    def set_event
      @event = @calendar.events.find(params[:id])
    end

    def set_variables
      @group = Group.includes(categories:{calendar: :events}).find(params[:group_id])
      @category = @group.categories.find(params[:category_id])
      @calendar = @category.calendar
      @authorised_member= is_user_of_group?(@group)
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
      unless @calendar
        redirect_to new_group_category_calendar_path(@group,@category)
      end
    end

    # edited from get_events from calendars_controller
    def get_events(period_start, period_end)

      day_start= period_start
      day_end= period_start.to_time.at_time_zone(@calendar.time_zone).end_of_day.to_datetime
      @events= @calendar.events.where.not("start >= ?", month_end).where.not("end <= ?", month_start).order(:start).all
      @mixed_events=@events.collect{|event|{google:false, event: event } }
      @google_events=[]
      if @calendar.google_calendar_id && @calendar.google_calendar_id.length>0
        #load google calendar events
        begin
          token = (current_user && current_user.google_account && current_user.google_account.fresh_token) || @calendar.google_account.fresh_token
          calendar_client = Signet::OAuth2::Client.new(access_token: token)
          calendar_service = Google::Apis::CalendarV3::CalendarService.new
          calendar_service.authorization = calendar_client
          result= calendar_service.list_events(@calendar.google_calendar_id, single_events: true,
            order_by: "startTime",time_max: period_end.rfc3339,
            time_min: period_start.rfc3339)
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
              order_by: "startTime",time_max: period_end.rfc3339,
              time_min: period_start.rfc3339)
            @google_events=result.items
          rescue
            @google_msg='There was an issue loading events from the Google Calendar.'
          end
        end
      end
      addition=@google_events.collect{|event|{google:true, event: event }}
      @mixed_events.concat(addition) if addition && !addition.empty?
    end

    # copied from google_settings from calendars_controller
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

    def set_google_event
      begin
        calendar_client = Signet::OAuth2::Client.new(access_token: current_user.google_account.fresh_token)
        calendar_service = Google::Apis::CalendarV3::CalendarService.new
        calendar_service.authorization = calendar_client
        @google_event=calendar_service.get_event(@calendar.google_calendar_id, params[:id])
      rescue Exception => e
        puts e.message
        begin
          google_settings
          calendar_client = Signet::OAuth2::Client.new(access_token: current_user.google_account.fresh_token)
          calendar_service = Google::Apis::CalendarV3::CalendarService.new
          calendar_service.authorization = calendar_client
          @google_event=calendar_service.get_event(@calendar.google_calendar_id, params[:id])
        rescue
          redirect_to group_category_calendar_path(@group, @category), notice: 'Unable to access event. Please sign in with Google through Settings if you have not done so or check the Google Calendar settings.'
          return
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:summary, :location, :description, :start, :end)
    end
end
