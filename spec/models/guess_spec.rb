require 'rails_helper'

RSpec.describe Guess do
  let(:char) { 'f' }
  let(:hangman_game) { 1 }
  let(:game) { HangmanGame.create(mystery_word: 'doesntmatter', initial_lives: 1) }

  describe 'testing guess validation' do
    context 'with invalid input' do
      let(:symbols) { [ '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '[',
                        ']', '{', '}' ] }

      it 'does not save symbols' do
        random_symbols = symbols.sample(3)

        expect(Guess.create(char: random_symbols.first, hangman_game: game)).to be_invalid
        expect(Guess.create(char: random_symbols.second, hangman_game: game)).to be_invalid
        expect(Guess.create(char: random_symbols.third, hangman_game: game)).to be_invalid
      end

      it 'does not save numbers' do
        expect(Guess.create(char: 1, hangman_game: game)).to be_invalid
        expect(Guess.create(char: 1000, hangman_game: game)).to be_invalid
      end

      it 'does not save multiple character inputs' do
        expect(Guess.create(char: 'foo', hangman_game: game)).to be_invalid
      end

      it 'does not save an input already guessed in a game' do
        Guess.create(char: 'f', hangman_game: game)

        expect(Guess.create(char: 'f', hangman_game: game)).to be_invalid
      end
    end

    context 'with valid input' do
      it 'saves' do
        expect(Guess.create(char: 'f', hangman_game: game)).to be_valid
      end
    end
  end
end
