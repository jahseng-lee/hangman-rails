class HangmanGame < ApplicationRecord
  has_many :guesses, dependent: :destroy

  validates :mystery_word, length: { minimum: 2 }
  validates :initial_lives, numericality: { greater_than: 0 }
  validates_presence_of :mystery_word, :lives
  validates_format_of :mystery_word, with: /\A[a-z]+\Z/

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

  def lost?
    lives == 0
  end

  def running?
    !lost? && !won?
  end

  def last_turn_correct?
    last_guess = guesses.order("created_at").last
    mystery_word.include? last_guess.char if last_guess
  end

  def incorrect_guesses
    guesses.not_in(mystery_word)
  end
end
