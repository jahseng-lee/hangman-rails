Rails.application.routes.draw do
  resources :hangman_game, only: [:index, :show, :create, :update]

  root 'home#index'
end
