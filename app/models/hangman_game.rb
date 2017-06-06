class HangmanGame < ApplicationRecord
  validates :mystery_word, presence: true, length: { minimum: 2 }
  validates :lives, presence: true, numericality: { greater_than: 0 }
  validate :mystery_word_is_alphabetical

  def mystery_word_is_alphabetical
    errors.add(:mystery_word, 'is not alphabetical') unless mystery_word.eql?(/^[A-Za-z]+$/)
  end
end
