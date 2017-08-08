Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root 'articles#index'
  
  resources  :users, only: [:edit, :update]
  devise_for :users
  
  resources :comments, only: [:create, :destroy] do
	collection do
		post 'inline_update'
	end
  end
  
  resources :articles do
	collection do
		get 'my', action: 'index_my'
	end
  end
  
  resources :tags, only: [:index, :show]
  
  get   'error/denied',    controller: 'welcome', action: 'error_access_denied'
  get   'error/not_found', controller: 'welcome', action: 'error_not_found'

end
