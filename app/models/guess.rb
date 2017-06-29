class Guess < ApplicationRecord
  belongs_to :hangman_game

  validate :hangman_game_running
  validates_format_of :letter, with: /\A[a-z]\Z/
  validates_presence_of :letter
  validates_uniqueness_of :letter, scope: :hangman_game_id, message: 'already guessed'

  scope :in, ->(word) { where("letter IN (?)", word.chars) }
  scope :not_in, ->(word) { where("letter NOT IN (?)", word.chars) }
  scope :incorrect_guesses_count, ->(word) { not_in(word).count }

  private

  def hangman_game_running
    hangman_game.running? || errors.add(:hangman_game, "is over")
  end
end
