class MakeGuess
  def initialize(hangman_game:, letter:)
    @hangman_game = hangman_game
    @letter = letter
    @guess = Guess.new(hangman_game: @hangman_game, letter: @letter.downcase)
  end

  def call
    @guess.save
  end

  def error_messages
    @guess.errors.full_messages
  end
end
