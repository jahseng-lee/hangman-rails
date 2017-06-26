class Guess < ApplicationRecord
  belongs_to :hangman_game

  validate :hangman_game_running
  validates_format_of :char, with: /\A[a-z]\Z/
  validates_presence_of :char
  validates_uniqueness_of :char, scope: :hangman_game_id, message: 'already guessed'

  scope :in, ->(word) { where("char IN (?)", word.chars) }
  scope :not_in, ->(word) { where("char NOT IN (?)", word.chars) }

  private

  def hangman_game_running
    hangman_game.running? || errors.add(:hangman_game, "is over")
  end
end
