class StaticsController < ApplicationController

	def show
		@slider_captions_list = [
			{img: ActionController::Base.helpers.asset_path('01.png'), title: 'Фотографиям вашего ребёнка позавидуют даже звёзды'},
			{img: ActionController::Base.helpers.asset_path('02.png'), title: 'Вас начнут приглашать все рекламные агентства страны'},
			{img: ActionController::Base.helpers.asset_path('03.png'), title: 'Самые яркие роли в фильмах  достанутся вашему ребёнку'},
		]
		
		@carousel_time_interval = 5000
		@carousel_fade_time     = 1000
	end
end
