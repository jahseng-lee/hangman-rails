module HangmanGameHelper
  INITIAL_LIVES = 11

  ERROR_TRANSLATIONS = {
    "Hangman game is over" => "This game is already completed!",
    "Char is invalid" => "The guess you entered isn't an alphabetical character.",
    "Char already guessed" => "You've already tried that character."
  }

  def self.random_word
    # TODO make this an actual random word
    "Powershop"
  end

  def self.translate_errors_for_user(errors_arr)
    errors_arr.map do |err|
      ERROR_TRANSLATIONS[err]
    end
  end
end
