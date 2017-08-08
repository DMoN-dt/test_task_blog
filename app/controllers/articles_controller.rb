PER_PAGE_ARTICLES_COUNT = 5

class ArticlesController < ApplicationController
  before_action :authenticate_and_authorize_user_action,             except: [:index, :show,   :edit,   :update, :destroy]
  before_action :set_article,                                        only:   [:show,  :edit,   :update, :destroy]
  before_action :authenticate_and_authorize_user_action_and_object,  only:   [:edit,  :update, :destroy]
  after_action  :verify_authorized,                                  except: [:index, :show]

  
  # GET /articles_my
  # GET /articles_my.json
  def index_my
    @tags = ActsAsTaggableOn::Tag.all
	
	page = ((params[:page].present? && params[:page].numeric?) ? params[:page].to_i : 1)
	
	@articles = Article.eager_load(:user).where(user_id: current_user.id).order('articles.created_at DESC').paginate(:page => page, :per_page => PER_PAGE_ARTICLES_COUNT)
	@current_user_id = current_user.id
	@title = 'Мои посты'
	render 'index'
  end
  
  
  # GET /articles
  # GET /articles.json
  def index
	@tags = ActsAsTaggableOn::Tag.all
	
	page = ((params[:page].present? && params[:page].numeric?) ? params[:page].to_i : 1)
	
    @articles = Article.eager_load(:user).where(is_published: true).order('articles.created_at DESC').paginate(:page => page, :per_page => PER_PAGE_ARTICLES_COUNT)
	@current_user_id = ((user_signed_in?) ? current_user.id : 0)
	@title = 'Список постов'
  end

  
  # GET /articles/1
  # GET /articles/1.json
  def show
	get_article_author
	@current_user_id = ((user_signed_in?) ? current_user.id : 0)
	@comments = Comment.eager_load(:user).where(article_id: @article.id).find_all
  end

  
  # GET /articles/new
  def new
    @article = Article.new
  end

  
  # GET /articles/1/edit
  def edit
  end

  
  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)
	@article.user_id = current_user.id

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Пост успешно создан.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  
  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Пост успешно обновлён.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  
  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to my_articles_url, notice: 'Пост удалён.' }
      format.json { head :no_content }
    end
  end

  
  private
	
	def authenticate_and_authorize_user_action
		authenticate_user!
		authorize Article
	end
	
	
	def authenticate_and_authorize_user_action_and_object
		authenticate_user!
		authorize @article
	end
	
	
    def set_article
		@article = Article.find(params[:id])
    end
	
	
	def get_article_author
		@author = User.where(id: @article.user_id).first
		if(@author.present?)
			@author_is_me = ((user_signed_in?) ? (@author.id == current_user.id) : false)
			
			if(!@article.is_published && !@author_is_me)
				if(stop_execute)
					redirect_to controller: 'welcome', action: 'error_not_found'
				else
					@author_name = nil
				end
			else
				get_article_author_name
			end
		else
			@author_name = nil
		end
		
		@author_name = 'Без имени' if(@author_name.blank?)
	end
	
	
	def get_article_author_name
		@author_name = @author.get_name_string
		if(@author_name.present?)
			@author_name = (@author.nickname + ' / ' + @author_name) if(@author.nickname.present?)
		else
			@author_name = @author.nickname
		end
    end

	
    def article_params
      p = params.require(:article).permit(:title, :content, :is_published, :created_at, :tag_list)
	  p[:tag_list] = p[:tag_list].split(/(\s)/) if(p[:tag_list].present?)
	  return p
    end
end
