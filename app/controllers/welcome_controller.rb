class WelcomeController < ApplicationController
	
	def error_access_denied
		if(flash[:alert])
			ie = flash[:alert].index(/(password|created_at|datetime|jsonb)/)
			if(ie.nil?)
				flash[:alert_show] = flash[:alert]
			else
				ii = flash[:alert].index(/[(:'"`]/)
				ii = ie if(ii.nil? or (ii > ie))
				flash[:alert_show] = flash[:alert][0,ii]
			end
			flash[:alert] = nil
		end
		
		render 'error_403', :status => 403
	end
	
	
	def error_not_found
		render 'error_404', :status => 404
	end

end
