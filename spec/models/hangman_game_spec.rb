require 'rails_helper'

RSpec.describe HangmanGame do
  let(:initial_lives) { 1 }
  let(:mystery_word) { 'abc' }
  subject(:game) { HangmanGame.create(mystery_word: mystery_word,
                                   initial_lives: initial_lives) }

  describe 'testing new game validation' do
    context 'with an empty word' do
      let(:mystery_word) { '' }

      it 'does not save' do
        expect(game).to be_invalid
      end

      it 'contains a mystery word error' do
        expect(game.errors[:mystery_word])
      end
    end

    context "with a word that has symbols" do
      let(:mystery_word) { '\@dabomb' }

      it 'does not save' do
        expect(game).to be_invalid
      end
    end

    context "with a word that has numbers" do
      let(:mystery_word) { 'l33t' }

      it 'does not save' do
        expect(game).to be_invalid
      end
    end

    context "with a word that has blank space" do
      let(:mystery_word) { 'hello darkness' }

      it 'does not save' do
        expect(game).to be_invalid
      end
    end

    context "with a singular character word" do
      let(:mystery_word) { 'h' }

      it 'does not save' do
        expect(game).to be_invalid
      end
    end

    context "with an alphabetical mystery word with more than 1 character" do
      let(:mystery_word) { 'hh' }

      it 'saves' do
        expect(game).to be_valid
      end
    end

    context "with 0 or less initial lives" do
      let(:initial_lives) { 0 }

      it 'does not save with 0 lives' do
        expect(game).to be_invalid
      end

      let(:initial_lives) { -1 }

      it 'does not save with -1 lives' do
        expect(game).to be_invalid
      end
    end
  end

  describe 'testing valid input' do
    let(:mystery_word) { 'abc' }

    context 'given input occuring in the mystery word' do
      let(:correct_input) { mystery_word.chars.first }
      before do
        create(:guess, :char => correct_input, :hangman_game => game)
      end

      it 'reveals the letter in masked word' do
        expect(game.masked_word).to eql([ 'a', nil, nil ])
      end

      it 'does not decrement life' do
        initial_lives = game.lives

        expect(game.lives).to eql(initial_lives)
      end
    end

    context 'given input not appearing in the mystery word' do
      let(:incorrect_input) { 'z' }

      it 'does not reveal any letters in masked word' do
        create(:guess, :char => incorrect_input, :hangman_game => game)

        expect(game.masked_word).to eql([ nil, nil, nil ])
      end

      it 'does decrement the players life' do
        initial_lives = game.lives
        create(:guess, :char => incorrect_input, :hangman_game => game)

        expect(game.lives).to eql(initial_lives - 1)
      end
    end
  end

  describe 'a game with uppercase letters in mystery word' do
    let(:mystery_word) { 'AbCc' }

    context 'given lowercase input' do
      it 'reveals the uppercase letter in the masked word' do
        create(:guess, :char => 'a', :hangman_game => game)

        expect(game.masked_word).to eql([ 'A', nil, nil, nil ])
      end

      it 'reveals all occurences of letter regardless of case' do
        create(:guess, :char => 'c', :hangman_game => game)

        expect(game.masked_word).to eql([ nil, nil, 'C', 'c' ])
      end
    end
  end

  describe 'testing all letters are guessed' do
    let(:mystery_word) { 'abc' }

    it 'wins the game' do
      create(:guess, :char => mystery_word.chars.first, :hangman_game => game)
      create(:guess, :char => mystery_word.chars.second, :hangman_game => game)
      create(:guess, :char => mystery_word.chars.third, :hangman_game => game)

      expect(game).to be_won
      expect(game).not_to be_running
    end
  end

  describe 'testing player runs out of lives' do
    let(:mystery_word) { 'abc' }
    let(:initial_lives) { 1 }

    it 'loses the game' do
      create(:guess, :char => 'y', :hangman_game => game)

      expect(game).not_to be_won
      expect(game).not_to be_running
    end
  end
end
