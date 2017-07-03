Feature: Finishing a game
  Background: a game exists

  Scenario: User loses a game
    Given there's only one life left
    When the user makes an incorrect guess
    Then the user loses the game

  Scenario: User wins a game
    Given there's atleast one life left
    When the user makes a correct guess
    And all the letters of the word are revealed
    Then the user wins the game
