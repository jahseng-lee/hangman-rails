Given(/^a Hangman Game exists$/) do
  FactoryGirl::create(:hangman_game, initial_lives: 3)
end

When(/^they click the "([^"]*)" button$/) do |arg1|
  click_button arg1
end
