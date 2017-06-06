require 'rails_helper'

RSpec.describe HangmanGame do
  describe 'with invalid fields' do
    it 'should not save with an empty mystery word' do
      game = HangmanGame.new(
        mystery_word: '',
        lives: 1
      )

      expect(game).to be_invalid
    end

    it 'should not save with a mystery word that has symbols' do
      game = HangmanGame.new(
        mystery_word: '\@dabomb',
        lives: 1
      )

      expect(game).to be_invalid
    end

    it 'should not save with a mystery word that has numbers' do
      game = HangmanGame.new(
        mystery_word: 'l33t',
        lives: 1
      )

      expect(game).to be_invalid
    end

    it 'should not save with a mystery word that has blank space' do
      game = HangmanGame.new(
        mystery_word: 'hello darkness',
        lives: 1
      )

      expect(game).to be_invalid
    end

    it 'should not save with a mystery word that is 1 character' do
      game = HangmanGame.new(
        mystery_word: 'h',
        lives: 1
      )

      expect(game).to be_invalid
    end

    it 'should not save with 0 or less initial lives' do
      game = HangmanGame.new(
        mystery_word: 'abc',
        lives: 0
      )

      expect(game).to be_invalid
    end
  end

  describe 'with correct input' do
    let(:mystery_word) { 'abc' }
    let(:game) { HangmanGame.new(
      mystery_word: mystery_word,
      lives: 1
    ) }

    it 'should reveal the letter in masked word' do
      game.guess(mystery_word.chars.first)

      expect(game.masked_word).to eql([ 'a', nil, nil ])
    end

    it 'should not decrement life' do
      initial_lives = game.lives
      game.guess(mystery_word.chars.first)

      expect(game.lives).to eql(initial_lives)
    end
  end

  describe 'with incorrect input' do
    let(:mystery_word) { 'abc' }
    let(:game) { HangmanGame.new(
      mystery_word: mystery_word,
      lives: 2
    ) }

    it 'should not reveal any letters in masked word' do
      game.guess('z')

      expect(game.masked_word).to eql([ nil, nil, nil])
    end

    it 'should decrement the players life' do
      initial_lives = game.lives
      game.guess(mystery_word.chars.first)

      expect(game.lives).to eql(initial_lives - 1)
    end
  end

  describe 'with uppercase input' do
    let(:mystery_word) { 'abc' }
    let(:game) { HangmanGame.new(
      mystery_word: mystery_word,
      lives: 1
    ) }

    it 'should reveal the letter in the masked word' do
      game.guess(mystery_word.chars.first.uppercase)

      expect(game.masked_word).to eql([ 'a', nil, nil ])
    end
  end

  describe 'with uppercase in the mystery word' do
    let(:mystery_word) { 'AbCc' }
    let(:game) { HangmanGame.new(
      mystery_word: mystery_word,
      lives: 1
    ) }

    it 'should reveal the uppercase letter in the masked word given lowercase input' do
      game.guess(mystery_word.chars.first.lowercase)

      expect(game.masked_word).to eql([ 'A', nil, nil, nil ])
    end

    it 'should reveal all occurences of letter regardless of case' do
      game.guess(mystery_word.chars.last)

      expect(game.masked_word).to eql([ nil, nil, 'C', 'c' ])
    end
  end

  describe 'if all letters are guessed' do
    let(:mystery_word) { 'abc' }
    let(:game) { HangmanGame.new(
      mystery_word: mystery_word,
      lives: 1
    ) }

    it 'should win the game' do
      game.guess(mystery_word.chars.first)
      game.guess(mystery_word.chars.second)
      game.guess(mystery_word.chars.third)

      expect(game).to be_won
      expect(game).not_to be_running
    end
  end

  describe 'if player runs out of lives' do
    let(:mystery_word) { 'abc' }
    let(:game) { HangmanGame.new(
      mystery_word: mystery_word,
      lives: 2
    ) }

    it 'should lose the game' do
      game.guess('x')
      game.guess('y')
      game.guess('z')

      expect(game).not_to be_won
      expect(game).not_to be_running
    end
  end

  describe 'input validator' do
    let(:mystery_word) { 'abc' }
    let(:game) { HangmanGame.new(
      mystery_word: mystery_word,
      lives: 1
    ) }

    let(:symbols) { [ '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '[',
                      ']', '{', '}' ] }

    it 'should not accept symbols' do
      random_symbols = symbols.sample(3)
      expect(game.valid_input?(random_symbols.first)).to be_falsey
      expect(game.valid_input?(random_symbols.second)).to be_falsey
      expect(game.valid_input?(random_symbols.third)).to be_falsey
    end

    it 'should not accept numeric input' do
      expect(game.valid_input?('1')).to be_falsey
      expect(game.valid_input?('9')).to be_falsey
    end

    it 'should not accept inputs with more than one character' do
      expect(game.valid_input?('ab')).to be_falsey
    end

    it 'should not accept empty inputs' do
      expect(game.valid_input?('')).to be_falsey
    end

    it 'should accept lowercase alphabetic inputs' do
      expect(game.valid_input?('B')).to be_falsey
    end

    it 'should accept uppercase alphabetic inputs' do
      expect(game.valid_input?('A')).to be_truthy
    end
  end
end
