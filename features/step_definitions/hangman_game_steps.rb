Given(/^a Hangman Game exists$/) do
  HangmanGame.create!(mystery_word: "foo", initial_lives: 3)
end

Given(/^user has started a game$/) do
  visit "/"
  click_button "New Game"
end

Given(/^they have entered a character into the guess field$/) do
  page.fill_in "guess", with: "f"
end

When(/^they click the "Hangman" link$/) do
  click_link "Hangman"
end

Then(/^they should see the (.+) button$/) do |button_name|
  expect(page).to have_button(button_name)
end

Then(/^feedback should be shown to the user$/) do
  expect(page).to have_text(/CORRECT|INCORRECT/)
end

Then(/^they should see the home page$/) do
  expect(page).to have_current_path("/")
end
