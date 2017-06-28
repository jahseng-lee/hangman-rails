Feature: Hangman Game
  Background:
    Given a Hangman Game exists

  Scenario: User wants to make a guess
    Given user has started a game
    And they have entered a character into the guess field
    When they click the "GO!" button
    Then feedback should be shown to the user

  Scenario: User wants to quit a game
    Given user has started a game
    When they click the "Hangman" link
    Then they should see the home page
