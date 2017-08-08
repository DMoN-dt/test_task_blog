class Comment < ApplicationRecord
	has_one    :user, :foreign_key => :id, :primary_key => :user_id
	has_one    :article, :foreign_key => :id, :primary_key => :article_id
	
	validates :content, presence: true
end
