class CreateContacts < ActiveRecord::Migration
  def up
    create_table :contacts do |t|
    	
    	t.string :name
    	t.string :organisation
    	t.string :position

    	t.string :email
    	t.string :phone
    	t.string :website

    	t.text :description

      t.timestamps null: false
    end
  end

  def down
  	drop_table :contacts
	end
end
