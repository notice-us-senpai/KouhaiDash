class TextPagesController < ApplicationController
  before_action :set_variables
  # before_action :set_text_page, only: [:show, :edit, :update, :destroy]

  # GET /text_pages
  # GET /text_pages.json
  def index
    @text_pages = TextPage.all
  end

  # GET /text_pages/1
  # GET /text_pages/1.json
  def show
    unless @text_page
      redirect_to new_group_category_text_page_path(@group,@category)
    end
  end

  # GET /text_pages/new
  def new
    @text_page = TextPage.new()
  end

  # GET /text_pages/1/edit
  def edit
  end

  # POST /text_pages
  # POST /text_pages.json
  def create
    @text_page = TextPage.new(text_page_params)
    @text_page.category = @category
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

  # PATCH/PUT /text_pages/1
  # PATCH/PUT /text_pages/1.json
  def update
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

  # DELETE /text_pages/1
  # DELETE /text_pages/1.json
  def destroy
    @text_page.destroy
    respond_to do |format|
      format.html { redirect_to @group, notice: 'Text page was successfully destroyed.' }
      format.json { head :no_content }
    end
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
      params.require(:text_page).permit(:title, :contents, :load_from_google, :file_id)
    end
end
