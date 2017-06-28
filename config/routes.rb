Rails.application.routes.draw do
  root 'home#index'

  resources :hangman_game, only: [:index, :show, :create, :update]
end
