Feature: Continue a game

  Scenario Outline: User continues game
    Given <a state> game exists
    And user clicks the "View Past Games" button
    When user clicks on the <state> game
    Then they should see the <state> game

    Examples:
      | a state       | state      |
      | an incomplete | incomplete |
      | a won         | won        |
      | a lost        | lost       |
