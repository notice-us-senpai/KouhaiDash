class TextPagesController < ApplicationController
  before_action :set_variables
  # before_action :set_text_page, only: [:show, :edit, :update, :destroy]
  before_action :check_view_auth
  before_action :check_edit_auth, only: [:edit, :update, :destroy, :new, :create]
  before_action :google_access_for_edit, only: [:edit, :update, :new, :create]

  def index
    #@text_pages = TextPage.all
  end

  def show
    if @text_page
      if @text_page.load_from_google
          begin
            #load using the uploader's google_account
            drive_client = Signet::OAuth2::Client.new(access_token: @text_page.google_account.fresh_token)
            drive_service = Google::Apis::DriveV3::DriveService.new
            drive_service.authorization = drive_client
            @contents = drive_service.export_file(@text_page.file_id, 'text/html')
          rescue
            #load from contents instead
            @contents=@text_page.contents
          end
      else
        @contents=@text_page.contents
      end
    else
      redirect_to new_group_category_text_page_path(@group,@category)
    end

  end

  def new
    @text_page = TextPage.new()
    @connected_to_google = (current_user.google_account && current_user.google_account.fresh_token.length>0)
  end

  def edit
  end

  def create
    @text_page = TextPage.new(text_page_params)
    @text_page.category = @category
    set_name_and_link
    respond_to do |format|
      if @text_page.save
        format.html { redirect_to [@group,@category,@text_page], notice: 'Text page was successfully created.' }
        format.json { render :show, status: :created, location: [@group,@category,@text_page] }
      else
        format.html { render :new }
        format.json { render json: @text_page.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    set_name_and_link
    respond_to do |format|
      if @text_page.update(text_page_params)
        format.html { redirect_to [@group,@category,@text_page], notice: 'Text page was successfully updated.' }
        format.json { render :show, status: :ok, location: [@group,@category,@text_page] }
      else
        format.html { render :edit }
        format.json { render json: @text_page.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @text_page.destroy
    respond_to do |format|
      format.html { redirect_to @group, notice: 'Text page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def to_authenticate
    store_location_url(
      if @text_page
        edit_group_category_text_page_path(@group,@category)
      else
        new_group_category_text_page_path(@group,@category)
      end)
    redirect_to '/auth/google_oauth2'
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_variables
      @group = Group.find(params[:group_id])
      @category = @group.categories.find(params[:category_id])
      @text_page = @category.text_page
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def text_page_params
      params.require(:text_page).permit(:title, :contents, :load_from_google, :file_id, :google_account_id)
    end

    def check_edit_auth
      check_category_edit_auth(@group,@category)
    end

    def check_view_auth
      if @category.type_no!=2
        flash[:notice]='Did you lost your way?'
        redirect_to @group
      end
      check_category_view_auth(@group,@category)
    end

    def google_access_for_edit
      @google_access = current_user.google_account && current_user.google_account.fresh_token.length>0
      #fresh_token is '' if refresh token fails ( ie access has failed )
      set_name_and_link
    end

    def set_name_and_link
      if @text_page && @text_page.google_account
        begin
          drive_client = Signet::OAuth2::Client.new(access_token: @text_page.google_account.fresh_token)
          drive_service = Google::Apis::DriveV3::DriveService.new
          drive_service.authorization = drive_client
          file= drive_service.get_file(@text_page.file_id, fields: 'name,web_view_link')
          @file_name=file.name
          @file_link=file.web_view_link
        rescue
        end
      end
    end
end
