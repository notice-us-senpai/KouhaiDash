class DisplaysController < ApplicationController
  before_action :set_variables
  before_action :check_view_auth
  before_action :check_edit_auth, only: [:edit, :update, :destroy, :new, :create]
  before_action :check_created, only:[:new, :create]
  before_action :google_access_for_edit, only: [:edit, :update, :new, :create]

  # GET /displays/1
  # GET /displays/1.json
  def show
    @supported_formats = Set.new ["image/jpeg","image/gif","image/png","image/bmp"]
    if @display
      begin
        #load using the uploader's google_account
        drive_client = Signet::OAuth2::Client.new(access_token: @display.google_account.fresh_token)
        drive_service = Google::Apis::DriveV3::DriveService.new
        drive_service.authorization = drive_client

        #set viewing permission of folder
        begin
          result=drive_service.create_permission(@display.google_folder_id,Google::Apis::DriveV3::Permission.new(role: 'reader', type: 'anyone'))
        rescue
        end

        #load images and videos
        @file_list = drive_service.list_files(q: "'#{@display.google_folder_id}' in parents and (mimeType contains 'image/' or mimeType contains 'video/') and trashed != true",
          fields: 'files(imageMediaMetadata/rotation,id,mimeType,thumbnailLink,webContentLink,webViewLink)')
        @images=@file_list.files.collect{|file |
          {mime: file.mime_type, thumbnail: file.thumbnail_link,
            content: file.web_content_link.chomp('&export=download'), view: file.web_view_link,
            rotation: (file.image_media_metadata && file.image_media_metadata.rotation)||0 }
        }

      rescue
        flash.now[:notice]='There was a problem loading the images from the specified google folder.'
      end
    else
      redirect_to new_group_category_display_path(@group,@category)
      return
    end


  end

  # GET /displays/new
  def new
    @display = Display.new
  end

  # GET /displays/1/edit
  def edit
    set_folder_name_and_link
  end

  # POST /displays
  # POST /displays.json
  def create
    @display = Display.new(display_params)
    @display.category=@category
    set_folder_name_and_link
    respond_to do |format|
      if @display.save
        format.html { redirect_to group_category_display_path(@group,@category), notice: 'Display was successfully created.' }
        format.json { render :show, status: :created, location: group_category_display_path(@group,@category) }
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
        format.html { redirect_to group_category_display_path(@group,@category), notice: 'Display was successfully updated.' }
        format.json { render :show, status: :ok, location: group_category_display_path(@group,@category) }
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
      format.html { redirect_to @group, notice: 'Display was successfully destroyed.' }
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
        @google_id = account.id
        #google_token, @google_id is nill if refresh fails ( ie access has failed and fresh_token = '')
      end
    end

    def set_folder_name_and_link
      if @display && @display.google_account

        begin
          drive_client = Signet::OAuth2::Client.new(access_token: @display.google_account.fresh_token)
          drive_service = Google::Apis::DriveV3::DriveService.new
          drive_service.authorization = drive_client
          file= drive_service.get_file(@display.google_folder_id, fields: 'name,web_view_link')
          @file_name=file.name
          @file_link=file.web_view_link
        rescue Exception => e
          puts e.message
        end
      end
    end

    def check_created
      if @display
        redirect_to group_category_display_path(@group,@category)
        return
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def display_params
      params.require(:display).permit(:title, :google_account_id, :google_folder_id, :display_type)
    end
end
