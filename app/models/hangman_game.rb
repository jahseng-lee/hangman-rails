class HangmanGame < ApplicationRecord
  has_many :guesses, dependent: :destroy

  validates :initial_lives, numericality: { greater_than: 0 }

  validates :mystery_word, length: { minimum: 2 }
  validates_presence_of :mystery_word, :initial_lives
  validates_format_of :mystery_word, with: /\A[a-z]+\Z/

  def correct_guesses
    guesses.in(mystery_word).pluck(:letter)
  end

  def incorrect_guesses
    guesses.not_in(mystery_word).pluck(:letter)
  end

  def lives
    initial_lives - guesses.incorrect_guesses_count(mystery_word)
  end

  def last_guess_correct?
    # TODO last_guess scope
    mystery_word.include? guesses.last if guesses.any?
  end

  def won?
    !lost? && (mystery_word.chars.uniq - correct_guesses).none?
  end

  def lost?
    lives.zero?
  end

  def running?
    # NOTE !(lost? || won?)
    !lost? && !won?
  end
end
