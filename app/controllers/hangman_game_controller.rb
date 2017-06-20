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
      redirect_to "https://http.cat/500";
    end
  end

  def update
    @game = HangmanGame.find(params[:id])
    service = MakeGuess.new(char: params[:guess], hangman_game: @game)

    unless service.call
      flash.now[:errors] = HangmanGameHelper.translate_errors_for_user(service.error_messages)
    else
      flash[:errors] = nil
    end

    render "show"
  end

  private

  def hangman_game_params
    params.require(:hangman_game).permit(:guess)
  end
end
