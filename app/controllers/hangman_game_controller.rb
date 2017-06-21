class HangmanGameController < ApplicationController
  def index
    @games = HangmanGame.all
  end

  def show
    @game = HangmanGame.find(params[:id])
  end

  def create
    service = MakeGame.new

    if service.call
      redirect_to service.game
    else
      redirect_to "https://http.cat/500"
    end
  end

  def update
    @game = HangmanGame.find(params[:id])
    service = MakeGuess.new(char: params[:guess], hangman_game: @game)

    if service.call
      flash[:errors] = nil
    else
      flash.now[:errors] = HangmanGameHelper.translate_errors_for_user(service.error_messages)
    end

    render "show"
  end

  private

  def hangman_game_params
    params.require(:hangman_game).permit(:guess)
  end
end
