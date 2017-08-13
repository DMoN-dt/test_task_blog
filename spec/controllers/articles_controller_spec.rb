require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
	describe "GET #index" do
		it "responds successfully" do
			get :index
			expect(response).to have_http_status(:ok)
		end
		
		it "assigns @articles with a correct count per page" do
			get :index
			expect((assigns(:articles).nil? ? 0 : assigns(:articles).size)).to be <= PER_PAGE_ARTICLES_COUNT
		end
	end

	
	describe "GET #index_my" do
		context "unregistered visitor" do
			it "should be redirected to signin" do
				get :index_my
				expect(response).to redirect_to(new_user_session_path)
			end
		end
		
		context "registered user" do
			login_user
			
			it "responds successfully" do
				get :index_my
				expect(response).to have_http_status(:ok)
			end
			
			it "assigns @articles with a correct count per page" do
				get :index_my
				expect((assigns(:articles).nil? ? 0 : assigns(:articles).size)).to be <= PER_PAGE_ARTICLES_COUNT
			end
		end
		
	end
	

	describe "GET #new" do
		context "unregistered visitor" do
			it "should be redirected to signin" do
				get :new
				expect(response).to redirect_to(new_user_session_path)
			end
		end
		
		context "registered user" do
			login_user
			
			it "responds successfully" do
				get :new
				expect(response).to have_http_status(:ok)
			end
		end
	end

	
	describe "POST #create" do
		context "unregistered visitor" do
			it "should be redirected to signin" do
				post :create
				expect(response).to redirect_to(new_user_session_path)
			end
		end
		
		context "registered user" do
			login_user
			new_article
			
			it "creates successfully" do
				post :create, params: {article: @article_attr}
				expect(response).to redirect_to(article_path(assigns(:article).id))
				expect(Article.exists?(title: @article_attr['title'])).to be true
			end
		end
	end

	
	describe "GET #edit" do
		article = Article.last
		
		context "unregistered visitor" do
			it "should be redirected to signin" do
				get :edit, params: {id: article.id}
				expect(response).to redirect_to(new_user_session_path)
			end
		end
		
		it "responds successfully to registered owner" do
			test_user = User.where(id: article.user_id).first
			sign_in test_user
			get :edit, params: {id: article.id}
			expect(response).to have_http_status(:ok)
		end
		
		it "responds with Forbidden to not owner" do
			not_owner_user = User.where.not(id: article.user_id).first
			((not_owner_user.present?) ? (sign_in not_owner_user) : login_user)
			
			get :edit, params: {id: article.id}
			expect(response).to have_http_status(:forbidden)
		end
	end
	
	
	describe "PATCH #update" do
		article = Article.last
		
		context "unregistered visitor" do
			it "should be redirected to signin" do
				patch :update, params: {id: article.id}
				expect(response).to redirect_to(new_user_session_path)
			end
		end
		
		it "responds successfully to registered owner" do
			test_user = User.where(id: article.user_id).first
			sign_in test_user
			article.title = 'тест_upd_' + Time.now.to_i.to_s
			patch :update, params: {id: article.id, article: article.attributes.except('id', 'created_at', 'updated_at', 'user_id')}
			expect(response).to redirect_to(article_path(id: article.id))
			expect(assigns(:article).title).to eq(article.title)
		end
		
		it "responds with Forbidden to not owner" do
			not_owner_user = User.where.not(id: article.user_id).first
			((not_owner_user.present?) ? (sign_in not_owner_user) : login_user)
			
			article.title = 'тест_upd_guest_' + Time.now.to_i.to_s
			patch :update, params: {id: article.id, article: article.attributes.except('id', 'created_at', 'updated_at', 'user_id')}
			expect(response).to have_http_status(:forbidden)
		end
	end

	
	describe "GET #show" do
		article = Article.last
		
		it "responds successfully" do
			get :show, params: {id: article.id}
			expect(response).to have_http_status(:ok)
		end
	end
	
	
	describe "PATCH #destroy" do
		article = Article.last
		
		context "unregistered visitor" do
			it "should be redirected to signin" do
				delete :destroy, params: {id: article.id}
				expect(response).to redirect_to(new_user_session_path)
			end
		end
		
		it "responds with Forbidden to not owner" do
			not_owner_user = User.where.not(id: article.user_id).first
			((not_owner_user.present?) ? (sign_in not_owner_user) : login_user)

			delete :destroy, params: {id: article.id}
			expect(response).to have_http_status(:forbidden)
		end
		
		context "registered owner" do
			login_user
			new_article
			
			it "responds successfully" do
				post :create, params: {article: @article_attr}
				article_id = assigns(:article).id
				expect(response).to redirect_to(article_path(article_id))
				
				delete :destroy, params: {id: article_id}
				expect(response).to redirect_to(my_articles_path)
				expect(Article.exists?(id: article_id)).to be false
			end
		end
	end
end
