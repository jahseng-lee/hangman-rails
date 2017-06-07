class HangmanGameController < ApplicationController
  def new
    if @game = HangmanGame.create(
        mystery_word: HangmanGameHelper.random_word,
        initial_lives: HangmanGameHelper::INITIAL_LIVES)
      render 'game'
    end
  end
end
