class Comment < ApplicationRecord
	has_one    :user, :foreign_key => :id, :primary_key => :user_id
	has_one    :article, :foreign_key => :id, :primary_key => :article_id
	
	validates_presence_of  :content, :article_id
	validates  :article_id, numericality: { only_integer: true }
	validate   :validate_article_id
	
	
	private

	def validate_article_id
		errors.add(:article_id, "is invalid") unless Article.exists?(self.article_id)
	end
end
