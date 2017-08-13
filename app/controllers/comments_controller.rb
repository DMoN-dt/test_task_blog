class CommentsController < ApplicationController
  before_action :authenticate_and_authorize_user_action,             except: [:inline_update, :destroy]
  before_action :set_comment,                                        only:   [:inline_update, :destroy]
  before_action :authenticate_and_authorize_user_action_and_object,  only:   [:inline_update, :destroy]
  after_action  :verify_authorized
  
  
  # POST /comments
  # POST /comments.json
  def create
    comment_params = params.require(:comment).permit(:content, :article_id)
	
	@comment = Comment.new(comment_params)
	@comment[:user_id] = current_user.id if(current_user.present?)

    respond_to do |format|
      if @comment.save
        @comment_id = @comment.id
		format.html { redirect_to article_path(id: comment_params[:article_id]), notice: 'Комментарий успешно добавлен.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  
  # POST /comments/inline_update.js
  def inline_update
	@comment_id = @comment.id
	
	if(@comment.created_at >= 15.minutes.ago)
		@update_ok = @comment.update(params.require(:comment).permit(:content))
	else
		@too_late = true
	end
	
	respond_to do |format|
      format.js
    end
  end

  
  # DELETE /comments/1.js
  def destroy
	@comment_id = @comment.id
	
	if(@comment.created_at >= 15.minutes.ago)
		@comment.destroy
	else
		@too_late = true
	end
	
    respond_to do |format|
      format.js
    end
  end

  
  private
	
	def authenticate_and_authorize_user_action
		authenticate_user!
		authorize Comment
	end
	
	
	def authenticate_and_authorize_user_action_and_object
		authenticate_user!
		authorize @comment
	end
	
	
	def set_comment
		@comment = Comment.find(params[:id].present? ? params[:id] : params.require(:comment).permit(:id)[:id])
    end
end
