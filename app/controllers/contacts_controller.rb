class ContactsController < ApplicationController
  before_action :set_variables
  before_action :get_contact, only: [:show, :edit, :update, :destroy]
  before_action :check_view_auth
  before_action :check_edit_auth, only: [:edit, :update, :destroy, :new, :create]

  def index
    @contacts = @category.contacts
    @file_prefix = @group.name+"-Contacts"
    respond_to do |format|
      format.html
      format.csv {
        send_data @contacts.to_csv,
        filename: "#{@file_prefix}-#{Date.today}.csv"
      }
    end
  end

  def show
  end

  def new
    @contact = @category.contacts.new
  end

  def create
    @contact = @category.contacts.new(contact_params)
    if @contact.save
      redirect_to action: 'index'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @contact.update_attributes(contact_params)
      redirect_to action: 'index'
    else
      render 'edit'
    end
  end

  def destroy
    @contact.destroy
    redirect_to action: 'index'
  end

  private

  def set_variables
    @group = Group.find(params[:group_id])
    @category = @group.categories.find(params[:category_id])
  end

  def check_edit_auth
    check_category_edit_auth(@group,@category)
  end

  def check_view_auth
    if @category.type_no!=1
      flash[:notice]='Did you lost your way?'
      redirect_to @group
    end
    check_category_view_auth(@group,@category)
  end

  def get_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(
      :name,
      :email,
      :number,
      :website,
      :organisation,
      :position,
      :description
    )
  end
end
