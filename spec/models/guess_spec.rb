require 'rails_helper'

RSpec.describe Guess do
  let(:char) { 'f' }
  let(:hangman_game_id) { 1 }
  let(:game) { HangmanGame.create(mystery_word: 'doesntmatter', initial_lives: 1) }
  # NOTE replace all hangman_game_id with game

  describe 'testing guess validation' do
    context 'with invalid input' do
      let(:symbols) { [ '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '[',
                        ']', '{', '}' ] }

      it 'does not save symbols' do
        random_symbols = symbols.sample(3)

        expect(Guess.create(char: random_symbols.first, hangman_game_id: game.id)).to be_invalid
        expect(Guess.create(char: random_symbols.second, hangman_game_id: game.id)).to be_invalid
        expect(Guess.create(char: random_symbols.third, hangman_game_id: game.id)).to be_invalid
      end

      it 'does not save numbers' do
        expect(Guess.create(char: 1, hangman_game_id: game.id)).to be_invalid
        expect(Guess.create(char: 1000, hangman_game_id: game.id)).to be_invalid
      end

      it 'does not save multiple character inputs' do
        expect(Guess.create(char: 'foo', hangman_game_id: game.id)).to be_invalid
      end

      it 'does not save an input already guessed in a game' do
        Guess.create(char: 'f', hangman_game_id: game.id)

        expect(Guess.create(char: 'f', hangman_game_id: game.id)).to be_invalid
      end
    end

    context 'with valid input' do
      it 'saves' do
        expect(Guess.create(char: 'f', hangman_game_id: game.id)).to be_valid
      end
    end
  end

  describe 'testing guesses' do
    let(:hangman_game_id) { 1 } # NOTE this is repeated above, ask mentors if this adds clarity

    context 'before any guesses have been made' do
      it 'returns an empty array' do
        # TODO shouldn't need to explicitly pass game id, can throw object in?
        # NOTE game.guesses?
        expect(Guess.guesses_for(hangman_game_id)).to eql([])
      end
    end

    context 'with some guesses' do

      it 'returns all guesses made in this game' do
        Guess.create(char: 'a', hangman_game_id: hangman_game_id)
        Guess.create(char: 'b', hangman_game_id: hangman_game_id)
        Guess.create(char: 'c', hangman_game_id: hangman_game_id)

        expect(Guess.guesses_for(hangman_game_id)).to eql([ 'a', 'b', 'c' ])
      end
    end

    context 'with guesses from other games' do
      let(:other_hangman_game_id) { 2 }

      it 'doesn\'t return any guesses from other games' do
        Guess.create(char: 'a', hangman_game_id: other_hangman_game_id)
        Guess.create(char: 'b', hangman_game_id: other_hangman_game_id)
        Guess.create(char: 'c', hangman_game_id: other_hangman_game_id)

        expect(Guess.guesses_for(hangman_game_id)).to eql([])
      end

      it 'only returns guesses from this game' do
        Guess.create(char: 'a', hangman_game_id: hangman_game_id)
        Guess.create(char: 'b', hangman_game_id: hangman_game_id)
        Guess.create(char: 'c', hangman_game_id: hangman_game_id)

        Guess.create(char: 'd', hangman_game_id: other_hangman_game_id)
        Guess.create(char: 'e', hangman_game_id: other_hangman_game_id)
        Guess.create(char: 'f', hangman_game_id: other_hangman_game_id)

        expect(Guess.guesses_for(hangman_game_id)).to eql([ 'a', 'b', 'c' ])
      end
    end
  end
end
