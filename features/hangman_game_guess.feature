Feature: Making guesses in a game
  Background: A game exists

  Scenario Outline: User guesses a letter
    Given User enters a <fancy variable name> letter
    When they submit the guess
    Then they should see the <turn result> message

    Examples:
      | fancy variable name            | turn result     |
      | letter in the mystery word     | correct guess   |
      | letter not in the mystery word | incorrect guess |

  Scenario Outline: User guesses a non valid input
    Given User enters a <fail at life> input
    When the submit the guess
    Then they should see a very degrading message

    Examples:
      | fail at life       |
      | symbol             |
      | number             |
      | multiple character |
      | empty              |
