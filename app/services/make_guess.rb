class MakeGuess
  def initialize(args)
    @hangman_game = args.fetch(:hangman_game, nil)
    @char = args.fetch(:char, nil)
  end

  def call
    Guess.new(hangman_game: @hangman_game, char: @char.downcase).save
  end
end
