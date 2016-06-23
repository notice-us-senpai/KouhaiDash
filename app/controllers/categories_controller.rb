class CategoriesController < ApplicationController
  before_action :set_group
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :check_edit_auth, only:[:index, :edit, :new, :update, :destroy, :create]
  before_action :set_type_no_array, only: [:new, :edit, :create, :update, :index]
  # GET /categories
  # GET /categories.json
  def index
    @categories = @group.categories
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    case @category.type_no
    when 2
      redirect_to group_category_text_page_path(@group,@category)
    when 3
      redirect_to group_category_tasks_path(@group,@category)
    else
    end
  end

  # GET /categories/new
  def new
    @category = @group.categories.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = @group.categories.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to [@group,@category], notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: [@group,@category] }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to [@group,@category], notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: [@group,@category] }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to group_categories_url, notice: 'Category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:group_id])
    end

    def set_category
      @category = @group.categories.find(params[:id])
    end

    def check_edit_auth
      unless is_user_of_group?@group
        flash[:notice] = "Join the group to see more!"
        redirect_to @group
      end
    end

    def set_type_no_array
      @type_no_array = [["Placeholder0",0],["Placeholder1",1],["Text Page",2],["Tasks List",3]]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :type_no, :group_id, :is_public)
    end
end
