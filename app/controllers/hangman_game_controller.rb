class HangmanGameController < ApplicationController
  def create
    @game = HangmanGame.new(
      mystery_word: HangmanGameHelper.random_word,
      initial_lives: HangmanGameHelper::INITIAL_LIVES)

    if @game.save
      redirect_to @game
    else
      flash[:error] = "Couldn't save"
    end
  end

  def index
    @games = HangmanGame.all
  end

  def show
    @game = HangmanGame.find(params[:id])
  end
end
