Given(/^a Hangman Game exists$/) do
  HangmanGame.create!(mystery_word: "foo", initial_lives: 3)
end

When(/^they click the "([^"]*)" button$/) do |arg1|
  click_button arg1
end
