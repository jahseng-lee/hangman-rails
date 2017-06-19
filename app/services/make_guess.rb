class MakeGuess
  def initialize(hangman_game:, char:)
    @hangman_game = hangman_game
    @char = char
    @guess = Guess.new(hangman_game: @hangman_game, char: @char.downcase)
  end

  def call
    @guess.save
  end

  def error_messages
    @guess.errors.full_messages
  end
end
