class User < ApplicationRecord
	has_many   :articles, :foreign_key => :user_id, :primary_key => :id
	has_many   :comments, :foreign_key => :user_id, :primary_key => :id
	
	validates  :name, length: { maximum: 50 }
	validates  :lastname, length: { maximum: 50 }
	validates  :nickname, length: { maximum: 50 }
	
	devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :lockable
		
	
	
	def is_allowed_to_cabinet?
		true
	end
	
	
	def is_allowed_write_comments?
		is_allowed_to_cabinet?
	end
	
	
	def get_name_string
		[self.lastname, self.name].join(' ').strip
	end
	
	
	def get_author_name
		author_name = get_name_string
		if(author_name.present?)
			author_name = (self.nickname + ' / ' + author_name) if(self.nickname.present?)
		else
			author_name = ((self.nickname.present?) ? self.nickname : 'Без имени')
		end
	end
	
	
	private

end
