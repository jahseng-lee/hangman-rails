require 'rails_helper'

RSpec.describe Guess do
  let(:letter) { 'f' }
  let(:hangman_game) { 1 }
  let(:game) { create(:hangman_game) }

  describe 'testing guess validation' do
    context 'with invalid input' do
      let(:symbols) {
        ['!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '[', ']', '{', '}']
      }

      it 'does not save symbols' do
        random_symbols = symbols.sample(3)

        expect(Guess.create(letter: random_symbols.first, hangman_game: game)).to be_invalid
        expect(Guess.create(letter: random_symbols.second, hangman_game: game)).to be_invalid
        expect(Guess.create(letter: random_symbols.third, hangman_game: game)).to be_invalid
      end

      it 'does not save numbers' do
        expect(Guess.create(letter: 1, hangman_game: game)).to be_invalid
        expect(Guess.create(letter: 1000, hangman_game: game)).to be_invalid
      end

      it 'does not save multiple letteracter inputs' do
        expect(Guess.create(letter: 'foo', hangman_game: game)).to be_invalid
      end

      it 'does not save a capitalized input' do
        expect(Guess.create(letter: 'F', hangman_game: game)).to be_invalid
      end

      it 'does not save an input already guessed in a game' do
        Guess.create(letter: 'f', hangman_game: game)

        expect(Guess.create(letter: 'f', hangman_game: game)).to be_invalid
      end
    end

    context 'with valid input' do
      it 'saves' do
        expect(Guess.create(letter: 'f', hangman_game: game)).to be_valid
      end
    end

    context 'when game is over' do
      let(:game) { create(:hangman_game) }
      let(:guess) { Guess.create(letter: 'f', hangman_game: game) }
      before do
        allow(game).to receive(:running?).and_return(false)
      end

      it 'does not save' do
        expect(guess).to be_invalid
      end

      it 'raises an error' do
        expect(guess.errors[:hangman_game])
      end
    end
  end

  describe "scopes" do
    context 'with correct guesses and incorrect guesses' do
      let(:game) { create(:hangman_game, mystery_word: "foobar", initial_lives: 10) }

      before do
        Guess.create(letter: 'f', hangman_game: game)
        Guess.create(letter: 'o', hangman_game: game)
        Guess.create(letter: 'z', hangman_game: game)
        Guess.create(letter: 'x', hangman_game: game)
      end

      describe "#in" do
        it 'returns all correct guesses' do
          expect(Guess.in(game.mystery_word).pluck(:letter)).to match_array(['f', 'o'])
        end
      end

      describe "#not_in" do
        context 'with correct guesses and incorrect guesses' do
          it 'returns all incorrect guesses' do
            expect(Guess.not_in(game.mystery_word).pluck(:letter)).to match_array(['z', 'x'])
          end
        end
      end
    end
  end
end
