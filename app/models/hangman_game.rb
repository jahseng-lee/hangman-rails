class HangmanGame < ApplicationRecord
  after_initialize :set_guesses

  validates :mystery_word, :mystery_word_is_alphabetical, length: { minimum: 2 }
  validates :initial_lives, numericality: { greater_than: 0 }
  validates :mystery_word, :lives, presence: true

  def set_guesses
    self.guesses = ''
  end

  def mystery_word_is_alphabetical
    errors.add(:mystery_word, 'is not alphabetical') unless mystery_word.eql?(/^[A-Za-z]+$/)
  end

  def guess(input)
    guesses << input.downcase
  end

  def masked_word
    mystery_word.chars.map do |c|
      if guesses.include? c.downcase
        c
      else
        nil
      end
    end
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
    initial_lives - incorrect_guesses.length
  end

  def won?
    mystery_word.chars.eql? masked_word
  end

  def running?
    lives > 0 && !won?
  end

  private

  def incorrect_guesses
    # NOTE compact feels really gross
    guesses.chars.map do |c|
      if mystery_word.downcase.exclude? c
        c
      end
    end.compact
  end
end
