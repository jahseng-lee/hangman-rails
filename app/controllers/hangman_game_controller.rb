class HangmanGameController < ApplicationController
  def new
    if @game = HangmanGame.create(
        mystery_word: HangmanGameHelper.random_word,
        initial_lives: HangmanGameHelper::INITIAL_LIVES)
      render 'game'
    end
  end

  def index
    @games = HangmanGame.all
  end

  def show
    @game = HangmanGame.find(params[:id])
    render 'game'
  end
end
