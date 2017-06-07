class HangmanGame < ApplicationRecord
  after_initialize :set_guesses

  validates :mystery_word, :mystery_word_is_alphabetical, length: { minimum: 2 }
  validates :initial_lives, numericality: { greater_than: 0 }
  validates_presence_of :mystery_word, :lives

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

  def set_guesses
    self.guesses = ''
  end

  def mystery_word_is_alphabetical
    if mystery_word[/^[A-Za-z]+$/]
      true
    else
      errors.add(:mystery_word, 'is not alphabetical') 
      false
    end
  end

  def duplicate?(input)
    guesses.chars.include? input
  end

  def single_alpha?(input)
    input.match(/^[[:alpha:]]$/)
  end

  def incorrect_guesses
    guesses.chars.select do |c|
      if mystery_word.downcase.exclude? c
        c
      end
    end
  end
end
