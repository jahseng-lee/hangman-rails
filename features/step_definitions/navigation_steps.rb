Given(/^user visits site$/) do
  visit "/"
end

Given(/^user visits the past games page$/) do
  visit "/"
  click_button "View Past Games"
end

When(/^they click on a game$/) do
  ## NOTE this relies on "Hangman" being a link in header
  # and the Given: user has started game to work
  page.find(:xpath, "(//a)[2]").click
end

Then(/^they should see a list of games$/) do
  expect(page).to have_current_path("/hangman_game")
end
