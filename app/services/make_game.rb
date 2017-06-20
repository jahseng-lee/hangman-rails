class MakeGame
  attr_reader :game

  ## --------
  # Constants
  INITIAL_LIVES = 11

  def initialize
    @game = HangmanGame.new(
      mystery_word: random_word,
      initial_lives: INITIAL_LIVES
    )
  end

  def call
    @game.save
  end

  private

  def random_word
    File.read('./app/assets/dictionary.txt').split("\n").sample
  end
end
