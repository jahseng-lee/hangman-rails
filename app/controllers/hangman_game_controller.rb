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
      initial_lives: HangmanGameHelper::INITIAL_LIVES
    )

    if @game.save
      redirect_to @game
    else
      @game.errors.add(:game, "Couldn't save")
      redirect_to "https://http.cat/500";
    end
  end

  def update
    if MakeGuess.new(hangman_game: HangmanGame.find(params[:id]), char: params[:guess]).call
      HangmanGame.find(params[:id]).errors.add(:game, "Couldn't update guesses")
    end

    redirect_to show
  end

  private

  def hangman_game_params
    params.require(:hangman_game).permit(:guess)
  end
end
