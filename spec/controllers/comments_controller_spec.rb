require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
	
	describe "POST #create" do
		context "unregistered visitor" do
			new_article_comment
		
			it "should be redirected to signin" do
				post :create, params: {comment: @comment_attr}
				expect(response).to redirect_to(new_user_session_path)
			end
		end
		
		context "registered user" do
			login_user
			new_article
			new_article_comment
			
			it "creates successfully" do
				post :create, params: {comment: @comment_attr}
				expect(response).to have_http_status(:ok)
			end
		end
	end

	
	describe "POST #inline_update" do
		comment = Comment.last
		
		context "unregistered visitor" do
			it "should be redirected to signin" do
				post :inline_update, params: {id: comment.id}
				expect(response).to redirect_to(new_user_session_path)
			end
		end
		
		it "responds successfully to registered owner" do
			test_user = User.where(id: comment.user_id).first
			sign_in test_user
			comment.content = 'тест_upd_' + Time.now.to_i.to_s
			post :inline_update, xhr: true, params: {id: comment.id, comment: comment.attributes.except('id', 'created_at', 'updated_at', 'user_id')}
			expect(response).to have_http_status(:ok)
			
			if(comment.created_at < 15.minutes.ago)
				expect(assigns(:comment).content).to_not eq(comment.content)
				
				comment.created_at = 14.minutes.ago
				comment.save
				comment.content = 'тест_upd1_' + Time.now.to_i.to_s
				
				post :inline_update, xhr: true, params: {id: comment.id, comment: comment.attributes.except('id', 'created_at', 'updated_at', 'user_id')}
				expect(response).to have_http_status(:ok)
				expect(assigns(:comment).content).to eq(comment.content)
				
			else
				expect(assigns(:comment).content).to eq(comment.content)
				
				comment.created_at = 15.minutes.ago
				comment.save
				comment.content = 'тест_upd2_' + Time.now.to_i.to_s
				
				post :inline_update, xhr: true, params: {id: comment.id, comment: comment.attributes.except('id', 'created_at', 'updated_at', 'user_id')}
				expect(response).to have_http_status(:ok)
				expect(assigns(:comment).content).to_not eq(comment.content)
			end
		end
		
		it "responds with Forbidden to not owner" do
			not_owner_user = User.where.not(id: comment.user_id).first
			((not_owner_user.present?) ? (sign_in not_owner_user) : login_user)
			
			comment.content = 'тест_upd_guest_' + Time.now.to_i.to_s
			post :inline_update, params: {id: comment.id, comment: comment.attributes.except('id', 'created_at', 'updated_at', 'user_id')}
			expect(response).to have_http_status(:forbidden)
		end
	end
	
	
	describe "POST #destroy" do
		comment = Comment.last
		
		context "unregistered visitor" do
			it "should be redirected to signin" do
				delete :destroy, params: {id: comment.id}
				expect(response).to redirect_to(new_user_session_path)
			end
		end

		it "responds with Forbidden to not owner" do
			not_owner_user = User.where.not(id: comment.user_id).first
			((not_owner_user.present?) ? (sign_in not_owner_user) : login_user)
			
			comment.content = 'тест_upd_' + Time.now.to_i.to_s
			delete :destroy, params: {id: comment.id}
			expect(response).to have_http_status(:forbidden)
		end
		
		context "registered owner" do
			login_user
			new_article
			new_article_comment

			it "responds successfully" do
				@article.save
				
				@comment.article_id = @article.id
				@comment.save

				delete :destroy, xhr: true, params: {id: @comment.id}
				expect(response).to have_http_status(:ok)
			end
		end
	end
	
	
end
