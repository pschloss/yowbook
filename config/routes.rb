Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  root 'static_pages#home'

  get '/help',      to: 'static_pages#help'
  get '/about',     to: 'static_pages#about'
  get '/contact',   to: 'static_pages#contact'
  get '/news',      to: 'static_pages#news'

	get '/signup',    to: 'shepherds#new'

	get '/login',     to: 'sessions#new'
	post '/login',    to: 'sessions#create'
	delete '/logout', to: 'sessions#destroy'

	resources :shepherds do
		member do
			get :following, :followers
		end
	end
	resources :shepherds
	resources :account_activations, only: [:edit]
	resources :password_resets,     only: [:new, :create, :edit, :update]
	resources :animals,             only: [:create, :destroy]
	resources :relationships,       only: [:create, :destroy]
end
