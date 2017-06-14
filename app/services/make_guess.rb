require './app/models/guess'

class MakeGuess
  def initialize(args)
    @hangman_game_id = args.fetch(:hangman_game_id, nil)
    @char = args.fetch(:char, nil)
  end

  def call
    Guess.create(hangman_game_id: @hangman_game_id, char: @char.downcase)
  end
end
