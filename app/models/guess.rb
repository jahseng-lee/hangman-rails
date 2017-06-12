class Guess < ApplicationRecord
  belongs_to :hangman_game

  validates_uniqueness_of :hangman_game_id, :scope => :char, :message => 'already guessed specified character'
  validates_format_of :char, :with => /\A[[:alpha:]]\Z/
  validates_presence_of :char, :hangman_game_id
end
