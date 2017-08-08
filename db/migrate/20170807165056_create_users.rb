class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
	  t.string      :name,       limit: 50
	  t.string      :lastname,   limit: 50
	  t.string      :nickname,   limit: 50
	  
      t.timestamps
    end
  end
end
