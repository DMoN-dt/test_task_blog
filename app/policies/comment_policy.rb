class CommentPolicy < ApplicationPolicy

	def create?
		user.is_allowed_write_comments?
	end
	
	def inline_update?
		is_allowed_to_record?
	end
	
	def destroy?
		is_allowed_to_record?
	end
	
	private
	
	def is_allowed_to_record?
		(user.is_allowed_write_comments? && (record.user_id == user.id))
	end
end
