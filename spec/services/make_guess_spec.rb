require 'rails_helper'

RSpec.describe MakeGuess do
  let(:game) { create(:hangman_game) }
  subject(:make_guess) { MakeGuess.new(char: char, hangman_game: game) }

  describe '#call' do
    context 'with valid parameters' do
      let(:char) { 'f' }

      it 'returns a truthy value' do
        expect(make_guess.call).to be_truthy
      end

      it 'creates a Guess' do
        expect { make_guess.call }.to change(game.guesses, :count).by(1)
      end
    end

    context 'with invalid parameters' do
      let(:char) { '' }

      it 'returns a falsey value' do
        expect(make_guess.call).to be_falsey
      end
    end
  end
end
