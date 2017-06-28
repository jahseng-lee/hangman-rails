When(/^they click the "([^"]*)" button$/) do |arg1|
  click_button arg1
end

Then(/^they should see a( new)? game$/) do |doesnt_matter|
  expect(page).to have_current_path(/\/hangman_game\/[0-9]+/)
end
