Rails.application.routes.draw do
  root 'static_pages#home'
  get '/help',      to: 'static_pages#help'
  get '/about',     to: 'static_pages#about'
  get '/contact',   to: 'static_pages#contact'
  get '/news',      to: 'static_pages#news'

	get '/signup',    to: 'shepherds#new'

	get '/login',     to: 'sessions#new'
	post '/login',    to: 'sessions#create'
	delete '/logout', to: 'sessions#destroy'

  get 'password_resets/new'
  get 'password_resets/edit'

	resources :shepherds do
		member do
			get :following, :followers
		end
	end
	get '/:id', to: 'shepherds#show'

	resources :shepherds
	resources :account_activations, only: [:edit]
	resources :password_resets,     only: [:new, :create, :edit, :update]
	resources :animals,             only: [:create, :destroy, :update]
	resources :relationships,       only: [:create, :destroy]

  get '/shepherds/:username/:eartag', to: 'animals#show', as: :shepherd_animal
  get '/shepherds/:username/:eartag/edit', to: 'animals#edit', as: :shepherd_animal_edit

end
