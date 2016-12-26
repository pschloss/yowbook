Rails.application.routes.draw do
  get 'users/new'

  root 'static_pages#home'

  get '/help',    to: 'static_pages#help'
  get '/about',   to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/news',    to: 'static_pages#news'

	get '/signup',	to: 'users#new'
end
