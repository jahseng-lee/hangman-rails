class HangmanGame < ApplicationRecord
  has_many :guesses, dependent: :destroy

  validates :mystery_word, length: { minimum: 2 }
  validates_format_of :mystery_word, :with => /\A[A-Za-z]+\Z/
  validates :initial_lives, numericality: { greater_than: 0 }
  validates_presence_of :mystery_word, :lives

  def masked_word
    mystery_word.chars.map do |c|
      if self.guesses.find_by char: c.downcase, hangman_game_id: self.id
        c
      else
        nil
      end
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

  private

  def duplicate?(input)
    self.guesses.find_by char: input, hangman_game_id: self.id
  end

  def single_alpha?(input)
    input.match(/^[[:alpha:]]$/)
  end

  def incorrect_guesses
    self.guesses.where("char NOT IN (?)", mystery_word.chars)
  end
end
