require 'rails_helper'

feature "the signup process" do
  given(:user) { FactoryBot.build(:user) }
  given(:invalid_user) { FactoryBot.build(:invalid_user) }

  scenario "has a new user page" do
    visit new_user_registration_path
    expect(page).to have_content "Register"
  end

  feature "valid signup information" do
    scenario "should log in upon successful signup" do
      expect(User.all.count).to eq(0)
      sign_up_as(user)
      expect(User.all.count).to eq(1)
      expect(page).to have_content "Welcome! You have signed up successfully."
      expect(page).to have_content "Logged in as testemail@example.com"
    end
  end

  feature "invalid signup information" do
    scenario "display error message upon unsuccessful signup" do
      expect(User.all.count).to eq(0)
      sign_up_as(invalid_user)
      expect(User.all.count).to eq(0)
      expect(page).to have_content "2 errors prohibited this user from being saved"
    end
  end
end
# 
# feature "logging in" do
#   given(:user) { FactoryBot.create(:user) }
#   given(:invalid_user) { FactoryBot.build(:invalid_user) }
#   
#   feature "valid login information" do
#     scenario "shows email on homepage after login" do
#       visit new_user_session_path
#       log_in_as(user)
#       expect(page).to have_content "Signed in successfully."
#       expect(page).to have_content "Logged in as testemail@example.com"
#     end
#   end
# 
#   feature "invalid information" do
#     scenario "shows email on homepage after login" do
#       visit new_user_session_path
#       log_in_as(invalid_user)
#       expect(page).to have_content "Invalid Email or password."
#     end
#   end
# end
# 
# feature "logging out" do
#   given(:user) { FactoryBot.create(:user) }
# 
#   scenario "begins with logged out state" do
#     visit root_path
#     expect(page).to have_content "Login"
#     expect(page).to_not have_content "Logout"
#   end
# 
#   scenario "doesn't show email on home page after logout" do
#     visit new_user_session_path
#     log_in_as(user)
#     click_link("Logout")
#     expect(page).to_not have_content("Logged in as testuser@example.com")
#   end
# end