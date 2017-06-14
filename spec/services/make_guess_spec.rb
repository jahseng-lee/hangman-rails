require 'rails_helper'

RSpec.describe MakeGuess do
  let(:char) { 'f' }
  let(:hangman_game_id) { 1 }
  subject(:make_guess) { MakeGuess.new(char: char, hangman_game_id: hangman_game_id) }

  describe 'call method' do
    context 'with valid parameters' do
      let(:game) { create(:hangman_game) }
      let(:hangman_game_id) { game.id }

      it 'returns a truthy value' do
        expect(make_guess.call).to be_truthy
      end

      it 'creates a Guess' do
        expect { make_guess.call }.to change(Guess, :count).by(1)
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
