class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|

    	t.string :username
    	t.string :password
    	
    	t.string :name
    	t.string :email

    	t.date :birthday
    	t.text :description
    	t.string :image

    	t.string :organisation
    	t.string :position

      t.timestamps null: false
    end
  end
  
  def down
  	drop_table :users
  end
end
