class HangmanGame < ApplicationRecord
  after_initialize :set_guesses

  validates :mystery_word, :mystery_word_is_alphabetical, length: { minimum: 2 }
  validates :lives, numericality: { greater_than: 0 }
  validates :mystery_word, :lives, presence: true

  def set_guesses
    self.guesses = ''
  end

  def mystery_word_is_alphabetical
    errors.add(:mystery_word, 'is not alphabetical') unless mystery_word.eql?(/^[A-Za-z]+$/)
  end

  def valid_input?(char)
    input = char.downcase
    single_alpha?(input) && !duplicate?(input)
  end

  def duplicate?(input)
    guesses.chars.include? input
  end

  def single_alpha?(input)
    input.match(/^[[:alpha:]]$/)
  end

  def lives
    initial_lives - guesses.length
  end
end
