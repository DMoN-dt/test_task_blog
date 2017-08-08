PER_PAGE_TAG_ARTICLES_COUNT = 5

class TagsController < ApplicationController
	def index
		@tags = ActsAsTaggableOn::Tag.all
	end
	
	def show
		page = ((params[:page].present? && params[:page].numeric?) ? params[:page].to_i : 1)
		@current_user_id = ((user_signed_in?) ? current_user.id : 0)
		
		@tag =  ActsAsTaggableOn::Tag.find(params[:id])
		@articles = Article.eager_load(:user).where(is_published: true).tagged_with(@tag.name).order('articles.created_at DESC').paginate(:page => page, :per_page => PER_PAGE_TAG_ARTICLES_COUNT)
	end
end
