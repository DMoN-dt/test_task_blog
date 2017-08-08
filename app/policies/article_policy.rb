class ArticlePolicy < ApplicationPolicy
	
	def index_my?
		user.is_allowed_to_cabinet?
	end
	
	def new?
		user.is_allowed_to_cabinet?
	end
	
	def create?
		user.is_allowed_to_cabinet?
	end
	
	def edit?
		is_allowed_to_record?
	end
	
	def update?
		is_allowed_to_record?
	end
	
	def destroy?
		is_allowed_to_record?
	end
	
	
	private
	
	def is_allowed_to_record?
		(user.is_allowed_to_cabinet? && (record.user_id == user.id))
	end
end
