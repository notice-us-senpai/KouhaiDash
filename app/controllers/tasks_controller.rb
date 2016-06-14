class TasksController < ApplicationController
  before_action :set_group
  before_action :set_category
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = @category.tasks.includes(task_assignments: [membership: :user]).all
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = @category.tasks.new()
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = @category.tasks.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to [@group, @category, @task], notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to [@group, @category, @task], notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to group_category_tasks_path(@group,@category), notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      # raise params.inspect
      @task = @category.tasks.find(params[:id])
      @users = @task.task_assignments.all.collect{|assign| assign.membership.user.username}
    end

    def set_category
      @category = @group.categories.find(params[:category_id])
    end

    def set_group
      @group = Group.find(params[:group_id])
      @memberships_array = @group.memberships.includes(:user).all.collect{|m|[m.user.username,m.id] }
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:name, :deadline, :description, :done, task_assignments_attributes: [:id, :membership_id, :_destroy])
    end

end
