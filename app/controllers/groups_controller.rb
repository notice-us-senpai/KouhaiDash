class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy, :join]
  before_action :check_user_of_group, only: [:edit, :update, :destroy]
  before_action :check_logged_in, only:[:new, :create, :join]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    change_group(@group)
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        @group.memberships.create(user_id: current_user.id, approved: true)
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /join_group/1
  def join
    @membership=@group.memberships.new(user_id: current_user.id, approved: false)
    if @membership.save
      flash[:notice] = "The request has been sent."
      redirect_to @group
    else
      flash[:error] = @membership.errors.full_messages
      redirect_to groups_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :members_public)
    end

    #checks if user if a member of the group
    def check_user_of_group
      unless logged_in?
        flash[:notice] = 'Log in as a member of the group.'
        redirect_to login_url
      end
      unless is_user_of_group?(@group)
        flash[:notice] = 'Join the group and wait for your request to be accepted!'
        redirect_to groups_path
      end
    end

    def check_logged_in
      unless logged_in?
        flash[:notice] = 'Please log in first.'
        redirect_to login_url
      end
    end
end
