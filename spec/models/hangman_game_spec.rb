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

      it 'reveals the letter in masked word' do
        game.guess(correct_input)

        expect(game.masked_word).to eql([ 'a', nil, nil ])
      end

      it 'does not decrement life' do
        initial_lives = game.lives
        game.guess(correct_input)

        expect(game.lives).to eql(initial_lives)
      end
    end

    context 'given input not appearing in the mystery word' do
      let(:incorrect_input) { 'z' }

      it 'does not reveal any letters in masked word' do
        game.guess(incorrect_input)

        expect(game.masked_word).to eql([ nil, nil, nil])
      end

      it 'does decrement the players life' do
        initial_lives = game.lives
        game.guess(incorrect_input)

        expect(game.lives).to eql(initial_lives - 1)
      end
    end

    context 'given uppercase input appearing in the word' do
      let(:uppercase_input) { 'A' }

      it 'reveals the letter in the masked word' do
        game.guess(uppercase_input)

        expect(game.masked_word).to eql([ 'a', nil, nil ])
      end
    end
  end

  describe 'a game with uppercase letters in mystery word' do
    let(:mystery_word) { 'AbCc' }

    context 'given lowercase input' do
      it 'reveals the uppercase letter in the masked word' do
        game.guess('a')

        expect(game.masked_word).to eql([ 'A', nil, nil, nil ])
      end

      it 'reveals all occurences of letter regardless of case' do
        game.guess('c')

        expect(game.masked_word).to eql([ nil, nil, 'C', 'c' ])
      end
    end
  end

  describe 'testing all letters are guessed' do
    let(:mystery_word) { 'abc' }

    it 'wins the game' do
      game.guess(mystery_word.chars.first)
      game.guess(mystery_word.chars.second)
      game.guess(mystery_word.chars.third)

      expect(game).to be_won
      expect(game).not_to be_running
    end
  end

  describe 'testing player runs out of lives' do
    let(:mystery_word) { 'abc' }
    let(:initial_lives) { 1 }

    it 'loses the game' do
      game.guess('y')

      expect(game).not_to be_won
      expect(game).not_to be_running
    end
  end

  describe 'testing input validator' do
    let(:mystery_word) { 'abc' }

    context 'with invalid inputs' do
      let(:symbols) { [ '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '[',
                        ']', '{', '}' ] }

      it 'rejects symbols' do
        random_symbols = symbols.sample(3)
        expect(game.valid_input?(random_symbols.first)).to be_falsey
        expect(game.valid_input?(random_symbols.second)).to be_falsey
        expect(game.valid_input?(random_symbols.third)).to be_falsey
      end

      it 'rejects numbers' do
        expect(game.valid_input?('1')).to be_falsey
        expect(game.valid_input?('9')).to be_falsey
      end

      it 'rejects multiple characters' do
        expect(game.valid_input?('ab')).to be_falsey
      end

      it 'rejects empty inputs' do
        expect(game.valid_input?('')).to be_falsey
      end

      it 'rejects letters already guessed' do
        game.guess('a')
        expect(game.valid_input?('a')).to be_falsey
      end
    end

    context 'with valid inputs' do
      it 'accepts lowercase alphabetic inputs' do
        expect(game.valid_input?('b')).to be_truthy
      end

      it 'accepts uppercase alphabetic inputs' do
        expect(game.valid_input?('A')).to be_truthy
      end
    end
  end
end
