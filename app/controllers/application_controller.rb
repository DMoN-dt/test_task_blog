class ApplicationController < ActionController::Base
  include Pundit
  
  protect_from_forgery with: :exception
  
  # RESCUEs
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  rescue_from ActionController::InvalidAuthenticityToken do |exception|
	if user_signed_in?
		sign_out current_user
	end
	flash[:error] = "Время сеанса истекло. Для продолжения, необходимо Войти вновь."
  	redirect_to new_user_session_path
  end
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
  	redirect_to controller: 'welcome', action: 'error_not_found'
  end
  
  
  Time::DATE_FORMATS[:input_datestr] = '%Y-%m-%dT%H:%M'

  
  def user_not_authorized(exception)
    if(Rails.env.development?)
		if(exception.message.present? && (exception.message.length > 1000))
			flash[:alert] = exception.message[0,512]
		else
			flash[:alert] = exception.message
		end
	end
	redirect_to controller: 'welcome', action: 'error_access_denied', status: 403
  end
  
  
  def after_sign_in_path_for(resource)
	return edit_user_path(id: current_user.id) if(current_user.name.blank? && current_user.lastname.blank?)
	return my_articles_path
  end
  
  
  private
  
end
