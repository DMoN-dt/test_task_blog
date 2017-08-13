class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
	  t.references :user, index: true, foreign_key: true
	  
	  t.references :article, null: false, index: true, foreign_key: true
      t.string     :content, null: false

      t.timestamps
    end
  end
end
