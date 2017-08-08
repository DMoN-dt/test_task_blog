class CommentsController < ApplicationController
  
  # POST /comments
  # POST /comments.json
  def create
    comment_params = params.require(:comment).permit(:content, :article_id)
	
	@comment = Comment.new(comment_params)
	@comment[:user_id] = current_user.id

    respond_to do |format|
      if @comment.save
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
	@comment = Comment.find(params.require(:comment).permit(:id)[:id])
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
    @comment = Comment.find(params[:id])
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

end
