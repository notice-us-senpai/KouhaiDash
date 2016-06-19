class TaskAssignmentsController < ApplicationController
  before_action :set_task_assignment, only: [:show, :edit, :update, :destroy]

  # GET /task_assignments
  # GET /task_assignments.json
  def index
    @task_assignments = TaskAssignment.all
  end

  # GET /task_assignments/1
  # GET /task_assignments/1.json
  def show
  end

  # GET /task_assignments/new
  def new
    @task_assignment = TaskAssignment.new
  end

  # GET /task_assignments/1/edit
  def edit
  end

  # POST /task_assignments
  # POST /task_assignments.json
  def create
    @task_assignment = TaskAssignment.new(task_assignment_params)

    respond_to do |format|
      if @task_assignment.save
        format.html { redirect_to @task_assignment, notice: 'Task assignment was successfully created.' }
        format.json { render :show, status: :created, location: @task_assignment }
      else
        format.html { render :new }
        format.json { render json: @task_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /task_assignments/1
  # PATCH/PUT /task_assignments/1.json
  def update
    respond_to do |format|
      if @task_assignment.update(task_assignment_params)
        format.html { redirect_to @task_assignment, notice: 'Task assignment was successfully updated.' }
        format.json { render :show, status: :ok, location: @task_assignment }
      else
        format.html { render :edit }
        format.json { render json: @task_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /task_assignments/1
  # DELETE /task_assignments/1.json
  def destroy
    @task_assignment.destroy
    respond_to do |format|
      format.html { redirect_to task_assignments_url, notice: 'Task assignment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task_assignment
      @task_assignment = TaskAssignment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_assignment_params
      params.require(:task_assignment).permit(:task_id, :membership_id)
    end
end
