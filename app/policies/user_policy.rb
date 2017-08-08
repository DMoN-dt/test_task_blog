class UserPolicy < ApplicationPolicy

	def edit?
		is_allowed_to_record?
	end
	
	def update?
		is_allowed_to_record?
	end
	
	private
	
	def is_allowed_to_record?
		(user.is_allowed_to_cabinet? && (record.id == user.id))
	end
end
