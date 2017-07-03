Feature: Making guesses in a game
  Background: a game exists

  Scenario Outline: User guesses a letter
    Given User enters a <fancy_variable_name> letter
    When they submit the guess
    Then they should see the <turn_result> message

    Examples:
      | fancy_variable_name            | turn_result     |
      | letter in the mystery word     | correct guess   |
      | letter not in the mystery word | incorrect guess |

  Scenario Outline: User guesses a non valid input
    Given User enters a <fail_at_life> input
    When the submit the guess
    Then they should see a very degrading message

    Examples:
      | fail_at_life       |
      | symbol             |
      | number             |
      | multiple character |
      | empty              |
