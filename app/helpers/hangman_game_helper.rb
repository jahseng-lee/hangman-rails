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
    game.mystery_word.chars.map do |c|
      if game.correct_guesses.include? c
        c
      else
        "_"
      end
    end.join(" ").capitalize
  end

  def format_guesses(guesses_arr)
    guesses_arr.join(" ")
  end
end
