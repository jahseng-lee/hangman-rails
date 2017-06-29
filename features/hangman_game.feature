Feature: Hangman Game
  Background:
    Given user has started a game

  Scenario: User wants to make a guess
    Given they have entered a character into the guess field
    When they click the "GO!" button
    Then feedback should be shown to the user

  Scenario: User wants to quit a game
    When they click the "Hangman" link
    Then they should see the home page
