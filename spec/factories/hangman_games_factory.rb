FactoryGirl.define do
  factory :hangman_game do
    mystery_word "abc"
    initial_lives 3
  end
end
