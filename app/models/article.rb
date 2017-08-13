class Article < ApplicationRecord
	has_one    :user, :foreign_key => :id, :primary_key => :user_id
	has_many   :comments, :foreign_key => :article_id, :primary_key => :id
	
	validates_presence_of :title, :content, :user_id
	
	acts_as_taggable
end
