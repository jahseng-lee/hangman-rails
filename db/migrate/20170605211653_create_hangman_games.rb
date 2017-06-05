class CreateHangmanGames < ActiveRecord::Migration[5.1]
  def change
    create_table :hangman_games do |t|
      t.integer :lives
      t.string :mystery_word
      t.string :guesses

      t.timestamps
    end
  end
end
