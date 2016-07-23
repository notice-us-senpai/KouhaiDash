class EventsController < ApplicationController
  before_action :set_variables
  before_action :check_view_auth
  before_action :check_edit_auth, only: [:edit, :update, :destroy, :new, :create]
  before_action :check_created
  before_action :set_event, only: [:edit, :update, :show, :destroy]

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
          event = Google::Apis::CalendarV3::Event.new({
            summary: @event.summary,
            location: @event.location,
            description: @event.description,
            start: {
              date_time: @event.start.rfc3339
            },
            end: {
              date_time: @event.end.rfc3339
            }
          })
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
  end

  private
    # Use callbacks to share common setup or constraints between actions.
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:summary, :location, :description, :start, :end)
    end
end
