class HangmanGameController < ApplicationController
  def index
    @games = HangmanGame.all
  end

  def show
    @game = HangmanGame.find(params[:id])
  end

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

  def update
    @game = HangmanGame.find(params[:id])

    if @game.guess(params[:guess])
      redirect_to @game
    else
      flash[:error] = "Couldn't update guesses"
    end
  end

  private

  def hangman_game_params
    params.require(:hangman_game).permit(:guess)
  end
end
