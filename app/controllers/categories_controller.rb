class CategoriesController < ApplicationController
  before_action :set_variables
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :check_edit_auth, only:[:index, :edit, :new, :update, :destroy, :create, :saveOrder]
  before_action :set_type_no_array, only: [:new, :edit, :create, :update, :index]
  # GET /categories
  # GET /categories.json
  def index
    @categories = @group.categories.order(:order_no)
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    case @category.type_no
    when 0
      redirect_to group_category_calendar_path(@group,@category)
    when 1
      redirect_to group_category_contacts_path(@group,@category)
    when 2
      redirect_to group_category_text_page_path(@group,@category)
    when 3
      redirect_to group_category_tasks_path(@group,@category)
    when 4
      redirect_to group_category_display_path(@group,@category)
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
      format.js
    end
  end

  def saveOrder
    order=params.require(:category).fetch(:order_no,[])
    i=1
    order.each do |category_id|
      category=@group.categories.find_by(id: category_id)
      category.update_attributes(order_no: i) if category
      i+=1
    end
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_variables
      @group = Group.includes(:categories).find(params[:group_id])
      @authorised_member= is_user_of_group?(@group)
    end

    def set_category
      @category = @group.categories.find(params[:id])
    end

    def check_edit_auth
      unless @authorised_member
        flash[:notice] = "Join the group to see more!"
        redirect_to @group
      end
    end

    def set_type_no_array
      @type_no_array = [["Calendar",0],["Contacts",1],["Text Page",2],["Tasks",3],["Gallery",4]]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :type_no, :is_public)
    end
end
