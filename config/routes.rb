Rails.application.routes.draw do
  get 'home/index'

  resources :hangman_game, only: [:index, :show, :create, :update]

  root 'home#index'
end
