class DisplaysController < ApplicationController
  before_action :set_variables
  before_action :check_view_auth
  before_action :check_edit_auth, only: [:edit, :update, :destroy, :new, :create]
  before_action :check_created, only:[:new, :create]
  before_action :google_access_for_edit, only: [:edit, :update, :new, :create]
  # GET /displays
  # GET /displays.json
  def index
    @displays = Display.all
  end

  # GET /displays/1
  # GET /displays/1.json
  def show
  end

  # GET /displays/new
  def new
    @display = Display.new
  end

  # GET /displays/1/edit
  def edit
  end

  # POST /displays
  # POST /displays.json
  def create
    @display = Display.new(display_params)

    respond_to do |format|
      if @display.save
        format.html { redirect_to @display, notice: 'Display was successfully created.' }
        format.json { render :show, status: :created, location: @display }
      else
        format.html { render :new }
        format.json { render json: @display.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /displays/1
  # PATCH/PUT /displays/1.json
  def update
    respond_to do |format|
      if @display.update(display_params)
        format.html { redirect_to @display, notice: 'Display was successfully updated.' }
        format.json { render :show, status: :ok, location: @display }
      else
        format.html { render :edit }
        format.json { render json: @display.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /displays/1
  # DELETE /displays/1.json
  def destroy
    @display.destroy
    respond_to do |format|
      format.html { redirect_to displays_url, notice: 'Display was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def to_authenticate
    store_location_url(
      if @display
        edit_group_category_display_path(@group,@category)
      else
        new_group_category_display_path(@group,@category)
      end)
    redirect_to '/auth/google_oauth2'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_variables
      @group = Group.find(params[:group_id])
      @category = @group.categories.find(params[:category_id])
      @display = @category.display
      @authorised_member= is_user_of_group?(@group)
    end

    def check_edit_auth
      unless @authorised_member
        category_edit_auth_redirect(@group,@category)
      end
    end

    def check_view_auth
      if @category.type_no!=4
        flash[:notice]='Did you lost your way?'
        redirect_to @group
      end
      unless @authorised_member
        check_category_view_auth(@group,@category)
      end
    end

    def google_access_for_edit
      account = current_user.google_account
      if account
        account.refresh!
        unless account.refresh_token.length>0
          revoke_google_token(account.access_token)
          flash.now[:notice] = 'Permissions from your google account has expired. Please sign in with google again to renew the permissions.'
        end
        @google_token = account && account.refresh_token.length>0 && account.fresh_token
        #google_token, @google_id is nill if refresh fails ( ie access has failed and fresh_token = '')
      end
    end

    def set_folder_name_and_link
      if @display && @display.google_account
        begin
          drive_client = Signet::OAuth2::Client.new(access_token: @text_page.google_account.fresh_token)
          drive_service = Google::Apis::DriveV3::DriveService.new
          drive_service.authorization = drive_client
          file= drive_service.get_file(@display.google_folder_id, fields: 'name,web_view_link')
          @file_name=file.name
          @file_link=file.web_view_link
        rescue
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def display_params
      params.require(:display).permit(:google_account_id, :google_folder_id, :display_type)
    end
end
