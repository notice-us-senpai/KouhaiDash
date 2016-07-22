class EventsController < ApplicationController
  before_action :set_variables
  before_action :check_view_auth
  before_action :check_edit_auth, only: [:edit, :update, :destroy, :new, :create]
  before_action :check_created
  before_action :google_access_for_edit, only: [:edit, :update, :new, :create]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
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

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
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
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    def set_variables
      @group = Group.find(params[:group_id])
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
      params.require(:event).permit(:calendar_id, :summary, :location, :description, :start, :end)
    end
end
