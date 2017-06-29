class MakeGuess
  attr_reader :guess

  def initialize(hangman_game:, letter:)
    @hangman_game = hangman_game
    @letter = letter
  end

  def call
    @guess = Guess.new(hangman_game: @hangman_game, letter: @letter.downcase)
    guess.save
  end

  def error_messages
    guess.errors.full_messages
  end
end
