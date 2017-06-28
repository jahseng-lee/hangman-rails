class HangmanGame < ApplicationRecord
  has_many :guesses, dependent: :destroy

  validates :mystery_word, length: { minimum: 2 }
  validates :initial_lives, numericality: { greater_than: 0 }
  validates_presence_of :mystery_word, :initial_lives
  validates_format_of :mystery_word, with: /\A[a-z]+\Z/

  def correct_guesses
    guesses.in(mystery_word).pluck(:letter)
  end

  def lives
    initial_lives - incorrect_guesses.length # NOTE scope for incorrect_guesses.length?
  end

  def won?
    mystery_word.chars.uniq.all? do |c|
      correct_guesses.include? c
    end
  end

  def lost?
    lives.zero?
  end

  def running?
    # NOTE !(lost? || won?)
    !lost? && !won?
  end

  def last_turn_correct?
    last_guess = guesses.order("created_at").last
    correct_guesses.include? last_guess.letter if last_guess
  end

  def incorrect_guesses
    guesses.not_in(mystery_word).pluck(:letter)
  end
end
