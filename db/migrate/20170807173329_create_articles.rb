class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.references :user, null: false, index: true, foreign_key: true
	  
	  t.string     :title, null: false
      t.string     :content, null: false
      t.boolean    :is_published, null: false, default: true

      t.timestamps
    end
  end
end
