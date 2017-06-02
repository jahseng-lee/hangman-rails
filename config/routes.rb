Rails.application.routes.draw do
  get 'home/index'

  resources :hangman_game

  root 'home#index'
end
