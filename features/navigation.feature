Feature: Navigation

  Scenario Outline: User wants to check out our website
    Given user visits site
    Then they should see the <button> button

    Examples:
      |button         |
      |New Game       |
      |View Past Games|
      |???            |

  Scenario: User wants to start a new game
    Given user visits site
    When they click the "New Game" button
    Then they should see a new game screen

  Scenario: User wants to view all past games
    Given user visits site
    When they click the "View Past Games" button
    Then they should see a list of games

  Scenario: User wants to continue a past game
    Given a Hangman Game exists
    And user visits the past games page
    When they click on a game
    Then they should see a game screen

