class RenameCharColumnForGuess < ActiveRecord::Migration[5.1]
  def change
    rename_column :guesses, :char, :letter
  end
end
