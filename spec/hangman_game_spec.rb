require 'rails_helper'

RSpec.describe HangmanGame do
  # TODO make these tests read like english
  let(:initial_lives) { 1 }
  let(:mystery_word) { 'abc' }
  subject(:game) { HangmanGame.create(mystery_word: mystery_word,
                                   initial_lives: initial_lives) }

  describe 'new game validation' do

    context 'with an empty word' do
      let(:mystery_word) { '' }

      it 'should not save' do
        expect(game).to be_invalid
      end
    end

    context "with a word that has symbols" do
      let(:mystery_word) { '\@dabomb' }

      it 'should not save' do
        expect(game).to be_invalid
      end
    end

    context "with a word that has numbers" do
      let(:mystery_word) { 'l33t' }

      it 'should not save' do
        expect(game).to be_invalid
      end
    end

    context "with a word that has blank space" do
      let(:mystery_word) { 'hello darkness' }

      it 'should not save' do
        expect(game).to be_invalid
      end
    end

    context "with a singular character word" do
      let(:mystery_word) { 'h' }

      it 'should not save' do
        expect(game).to be_invalid
      end
    end

    context "with an alphabetical mystery word with more than 1 character" do
      let(:mystery_word) { 'hh' }

      it 'should save' do
        expect(game).to be_invalid
      end
    end

    context "with 0 or less initial lives" do
      let(:initial_lives) { 0 }

      it 'should not save with 0 lives' do
        expect(game).to be_invalid
      end

      let(:initial_lives) { -1 }

      it 'should not save with -1 lives' do
        expect(game).to be_invalid
      end
    end
  end

  describe 'valid input' do
    let(:mystery_word) { 'abc' }

    context 'given correct input' do
      let(:correct_input) { mystery_word.chars.first }

      it 'should reveal the letter in masked word' do
        game.guess(correct_input)

        expect(game.masked_word).to eql([ 'a', nil, nil ])
      end

      it 'should not decrement life' do
        initial_lives = game.lives
        game.guess(correct_input)

        expect(game.lives).to eql(initial_lives)
      end
    end

    context 'given incorrect input' do
      let(:incorrect_input) { 'z' }

      it 'should not reveal any letters in masked word' do
        game.guess(incorrect_input)

        expect(game.masked_word).to eql([ nil, nil, nil])
      end

      it 'should decrement the players life' do
        initial_lives = game.lives
        game.guess(incorrect_input)

        expect(game.lives).to eql(initial_lives - 1)
      end
    end

    context 'given uppercase input' do
      let(:uppercase_input) { 'A' }

      it 'should reveal the letter in the masked word' do
        game.guess(uppercase_input)

        expect(game.masked_word).to eql([ 'a', nil, nil ])
      end
    end
  end

  describe 'uppercase in mystery word' do
    let(:mystery_word) { 'AbCc' }

    context 'lowercase input' do
      it 'should reveal the uppercase letter in the masked word' do
        game.guess('a')

        expect(game.masked_word).to eql([ 'A', nil, nil, nil ])
      end

      it 'should reveal all occurences of letter regardless of case' do
        game.guess('c')

        expect(game.masked_word).to eql([ nil, nil, 'C', 'c' ])
      end
    end
  end

  describe 'all letters are guessed' do
    let(:mystery_word) { 'abc' }

    it 'should win the game' do
      game.guess(mystery_word.chars.first)
      game.guess(mystery_word.chars.second)
      game.guess(mystery_word.chars.third)

      expect(game).to be_won
      expect(game).not_to be_running
    end
  end

  describe 'player runs out of lives' do
    let(:mystery_word) { 'abc' }
    let(:lives) { 2 }

    it 'should lose the game' do
      game.guess('x')
      game.guess('y')

      expect(game).not_to be_won
      expect(game).not_to be_running
    end
  end

  describe 'input validator' do
    let(:mystery_word) { 'abc' }

    context 'invalid inputs' do
      let(:symbols) { [ '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '[',
                        ']', '{', '}' ] }

      it 'should reject symbols' do
        random_symbols = symbols.sample(3)
        expect(game.valid_input?(random_symbols.first)).to be_falsey
        expect(game.valid_input?(random_symbols.second)).to be_falsey
        expect(game.valid_input?(random_symbols.third)).to be_falsey
      end

      it 'should reject numbers' do
        expect(game.valid_input?('1')).to be_falsey
        expect(game.valid_input?('9')).to be_falsey
      end

      it 'should reject multiple characters' do
        expect(game.valid_input?('ab')).to be_falsey
      end

      it 'should reject empty inputs' do
        expect(game.valid_input?('')).to be_falsey
      end

      it 'should reject letters already guessed' do
        game.guess('a')
        expect(game.valid_input?('a')).to be_falsey
      end
    end

    context 'valid inputs' do
      it 'should accept lowercase alphabetic inputs' do
        expect(game.valid_input?('b')).to be_truthy
      end

      it 'should accept uppercase alphabetic inputs' do
        expect(game.valid_input?('A')).to be_truthy
      end
    end
  end
end
