class UsersController < ApplicationController
	before_action :set_user
	before_action :authenticate_and_authorize_user_action_and_object
	after_action  :verify_authorized
	
	# GET /users/1/edit
	def edit
	end
	
	
	# PATCH/PUT /users/1
	# PATCH/PUT /users/1.json
	def update
		respond_to do |format|
		if @user.update(user_params)
			format.html { redirect_to root_path, notice: 'Информация о пользователе успешно обновлена.' }
			format.json { render :show, status: :ok, location: @user }
		else
			format.html { render :edit }
			format.json { render json: @user.errors, status: :unprocessable_entity }
		end
		end
	end
	
	
	private
	
	def authenticate_and_authorize_user_action_and_object
		authenticate_user!
		authorize @user
	end
	
    def set_user
		@user = ((params[:id].blank?) ? current_user : User.find(params[:id]))
    end

    def user_params
      params.require(:user).permit(:name, :lastname, :nickname)
    end
end
