module HangmanGameHelper
  ERROR_TRANSLATIONS = {
    "Hangman game is over" => "This game is already completed!",
    "Letter is invalid" => "The guess you entered isn't an alphabetical letteracter.",
    "Letter already guessed" => "You've already tried that letteracter."
  }.freeze

  def translate_errors_for_user(errors_arr)
    if errors_arr.include? "Hangman game is over"
      [ERROR_TRANSLATIONS["Hangman game is over"]]
    else
      errors_arr.map do |err|
        ERROR_TRANSLATIONS[err]
      end
    end
  end

  def masked_word(game)
    game.mystery_word.chars.map do |char|
      (game.correct_guesses.include? char) ? char : "_"
    end.join(" ").capitalize
  end

  def format_guesses(guesses_arr)
    guesses_arr.join(" ")
  end

  def listing_class(game)
    "game-listing".tap do |listing_class|
      listing_class << "-won" if game.won?
      listing_class << "-lost" if game.lost?
    end
  end
end
