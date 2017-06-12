class ChangeGameIdGuesses < ActiveRecord::Migration[5.1]
  def change
    rename_column :guesses, :game_id, :hangman_game_id
  end
end
