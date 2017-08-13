module ControllerMacros
  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl.create(:user)
      # user.confirm! # Only necessary if you are using the "confirmable" module (or set a confirmed_at inside the factory)
      sign_in @user
    end
  end
  
  
  def new_article 
    before(:each) do
      @article = FactoryGirl.build(:article, user_id: @user.id)
      @article_attr = @article.attributes.except('id', 'created_at', 'updated_at', 'user_id')
    end
  end
  
  
  def new_article_comment
    before(:each) do
      @comment = FactoryGirl.build(:comment, user_id: (@user.blank? ? nil : @user.id), article_id: (@article.nil? ? 0 : @article.id.to_i))
      @comment_attr = @comment.attributes.except('id', 'created_at', 'updated_at', 'user_id')
    end
  end
  
end