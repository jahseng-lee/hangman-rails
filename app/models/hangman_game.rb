class HangmanGame < ApplicationRecord
  has_many :guesses, dependent: :destroy

  validates :mystery_word, length: { minimum: 2 }
  validates_format_of :mystery_word, with: /\A[A-Za-z]+\Z/
  validates :initial_lives, numericality: { greater_than: 0 }
  validates_presence_of :mystery_word, :lives

  def masked_word
    mystery_word.chars.map do |c|
      c if guesses.find_by char: c.downcase, hangman_game_id: id
    end
  end

  def lives
    initial_lives - incorrect_guesses.length
  end

  def won?
    mystery_word.chars.eql? masked_word
  end

  def running?
    lives > 0 && !won?
  end

  def last_turn_correct?
    last_guess = guesses.last
    mystery_word.downcase.include? last_guess.char unless last_guess.nil?
  end

  def incorrect_guesses
    guesses.not_in(mystery_word)
  end
end
