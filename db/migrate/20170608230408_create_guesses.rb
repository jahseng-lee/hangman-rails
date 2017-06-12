class CreateGuesses < ActiveRecord::Migration[5.1]
  def change
    create_table :guesses do |t|
      t.string :char
      t.integer :game_id

      t.timestamps
    end
  end
end
