require 'rails_helper'

RSpec.describe Guess do
  let(:char) { 'f' }
  let(:game_id) { 1 }

  describe 'testing guess validation' do
    context 'with invalid input' do
      let(:symbols) { [ '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '[',
                        ']', '{', '}' ] }

      it 'does not save symbols' do
        random_symbols = symbols.sample(3)

        expect(Guess.create(char: random_symbols.first, game_id: game_id)).to be_falsey
        expect(Guess.create(char: random_symbols.second, game_id: game_id)).to be_falsey
        expect(Guess.create(char: random_symbols.third, game_id: game_id)).to be_falsey
      end

      it 'does not save a number' do
        expect(Guess.create(char: 1, game_id: game_id)).to be_falsey
        expect(Guess.create(char: 1000, game_id: game_id)).to be_falsey
      end

      it 'does not save a multiple character input' do
        expect(Guess.create(char: 'foo', game_id: game_id)).to be_falsey
      end

      it 'does not save an input already guess in a game' do
        # TODO
      end
    end

    context 'with valid input' do
      it 'saves' do
        expect(Guess.create(char: 'f', game_id: game_id)).to be_truthy
      end
    end
  end

  describe 'testing guesses' do
    let(:game_id) { 1 } # NOTE this is repeated above, ask montors if this adds clarity

    context 'before any guesses have been made' do
      it 'returns an empty array' do
        expect(Guess.guesses_for(game_id)).to eql([])
      end
    end

    context 'with some guesses' do

      it 'returns all guesses made in this game' do
        Guess.create(char: 'a', game_id: game_id)
        Guess.create(char: 'b', game_id: game_id)
        Guess.create(char: 'c', game_id: game_id)

        expect(Guess.guesses_for(game_id)).to eql([ 'a', 'b', 'c' ])
      end
    end

    context 'with guesses from other games' do
      let(:other_game_id) { 2 }
      it 'doesn\'t return any guesses from other games' do
        Guess.create(char: 'a', game_id: other_game_id)
        Guess.create(char: 'b', game_id: other_game_id)
        Guess.create(char: 'c', game_id: other_game_id)

        expect(Guess.guesses_for(game_id)).to eql([])
      end

      it 'only returns guesses from this game' do
        Guess.create(char: 'a', game_id: game_id)
        Guess.create(char: 'b', game_id: game_id)
        Guess.create(char: 'c', game_id: game_id)

        Guess.create(char: 'd', game_id: other_game_id)
        Guess.create(char: 'e', game_id: other_game_id)
        Guess.create(char: 'f', game_id: other_game_id)

        expect(Guess.guesses_for(game_id)).to eql([ 'a', 'b', 'c' ])
      end
    end
  end
end
