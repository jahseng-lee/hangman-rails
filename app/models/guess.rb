class Guess < ApplicationRecord
  belongs_to :hangman_game

  validate :game_is_running
  validates_format_of :char, with: /\A[[:alpha:]]\Z/
  validates_presence_of :char, :hangman_game_id
  validates_uniqueness_of :char, scope: :hangman_game_id, message: 'already guessed'

  private

  def game_is_running
    hangman_game.running? || errors.add(:hangman_game, "is over")
  end
end
