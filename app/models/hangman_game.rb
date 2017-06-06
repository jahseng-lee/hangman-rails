class HangmanGame < ApplicationRecord
  validates :mystery_word, :mystery_word_is_alphabetical, length: { minimum: 2 }
  validates :lives, numericality: { greater_than: 0 }
  validates :mystery_word, :lives, presence: true

  def mystery_word_is_alphabetical
    errors.add(:mystery_word, 'is not alphabetical') unless
    mystery_word.eql?(/^[A-Za-z]+$/)
  end
end
