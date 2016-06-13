class ContactsController < ApplicationController
	before_action :get_contact, only: [:show, :edit, :update, :destroy]

  def index
  	@contacts = Contact.all
  end

  def show
  end

  def new
  	@contact = Contact.new
  end

  def create
  	@contact = Contact.new(contact_params)
  	if @contact.save
  		redirect_to action: 'index'
		else
			render 'new'
		end
	end

  def edit
  end

  def update
  	if @contact.update_attributes(student_params)
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
