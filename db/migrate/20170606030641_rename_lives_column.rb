class RenameLivesColumn < ActiveRecord::Migration[5.1]
  def change
    rename_column :hangman_games, :lives, :initial_lives
  end
end
