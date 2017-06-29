class MakeGame
  attr_reader :game

  INITIAL_LIVES = 11

  def call
    @game = HangmanGame.new(
      mystery_word: random_word.downcase,
      initial_lives: INITIAL_LIVES
    )
    game.save
  end

  private

  def random_word
    File.read('./app/assets/dictionary.txt').split("\n").sample
  end
end
