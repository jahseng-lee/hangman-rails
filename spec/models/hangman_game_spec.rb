require "rails_helper"

RSpec.describe HangmanGame do
  let(:initial_lives) { 1 }
  let(:mystery_word) { "abc" }
  subject(:game) {
    HangmanGame.create(mystery_word: mystery_word, initial_lives: initial_lives)
  }

  describe "testing new game validation" do
    context "with an empty word" do
      let(:mystery_word) { "" }

      it "does not save" do
        expect(game).to be_invalid
      end

      it "contains a mystery word error" do
        expect(game.errors[:mystery_word])
      end
    end

    context "with a word that has symbols" do
      let(:mystery_word) { "\@dabomb" }

      it "does not save" do
        expect(game).to be_invalid
      end
    end

    context "with a word that has numbers" do
      let(:mystery_word) { "l33t" }

      it "does not save" do
        expect(game).to be_invalid
      end
    end

    context "with a word that has blank space" do
      let(:mystery_word) { "hello darkness" }

      it "does not save" do
        expect(game).to be_invalid
      end
    end

    context "with a singular letteracter word" do
      let(:mystery_word) { "h" }

      it "does not save" do
        expect(game).to be_invalid
      end
    end

    context "with an alphabetical word containing atleast 2 letteracters" do
      context "containing uppercase chars" do
        let(:mystery_word) { "Hh" }

        it "does not save" do
          expect(game).to be_invalid
        end
      end

      context "with an alphabetical mystery word with more than 1 letteracter" do
        let(:mystery_word) { "hh" }

        it "saves" do
          expect(game).to be_valid
        end
      end
    end

    context "with 0 or less initial lives" do
      let(:initial_lives) { 0 }

      it "does not save with 0 lives" do
        expect(game).to be_invalid
      end

      let(:initial_lives) { -1 }

      it "does not save with -1 lives" do
        expect(game).to be_invalid
      end
    end
  end

  describe "testing valid input" do
    let(:mystery_word) { "abc" }

    context "given input occuring in the mystery word" do
      let(:correct_input) { mystery_word.chars.first }

      describe "#correct_guesses" do
        it "returns the correct guess" do
          create(:guess, letter: correct_input, hangman_game: game)

          expect(game.correct_guesses).to match_array([correct_input])
        end
      end

      it "does not decrement life" do
        initial_lives = game.lives
        create(:guess, letter: correct_input, hangman_game: game)

        expect(game.lives).to eql(initial_lives)
      end
    end

    context "given input not appearing in the mystery word" do
      let(:mystery_word) { "abc" }
      let(:incorrect_input) { "z" }

      describe "#incorrect_guesses" do
        it "returns the incorrect guess" do
          create(:guess, letter: incorrect_input, hangman_game: game)

          expect(game.incorrect_guesses).to match_array([incorrect_input])
        end
      end

      it "does decrement the players life" do
        initial_lives = game.lives
        create(:guess, letter: incorrect_input, hangman_game: game)

        expect(game.lives).to eql(initial_lives - 1)
      end
    end
  end

  describe "testing all chars are guessed" do
    let(:mystery_word) { "abc" }

    it "wins the game" do
      create(:guess, letter: mystery_word.chars.first, hangman_game: game)
      create(:guess, letter: mystery_word.chars.second, hangman_game: game)
      create(:guess, letter: mystery_word.chars.third, hangman_game: game)

      expect(game).to be_won
      expect(game).not_to be_running
    end
  end

  describe "testing player runs out of lives" do
    let(:mystery_word) { "abc" }
    let(:initial_lives) { 1 }

    it "loses the game" do
      create(:guess, letter: "y", hangman_game: game)

      expect(game).not_to be_won
      expect(game).not_to be_running
    end
  end
end
