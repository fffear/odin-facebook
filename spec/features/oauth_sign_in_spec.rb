require 'rails_helper'

feature 'Sign in with Facebook' do
  background(:each) {
    Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] # If using Devise
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
  }

  scenario 'with valid email and password' do
    visit root_path
    expect(page).to have_content "Sign in with Facebook"
    expect(User.all.count).to eq(0)
    click_link("Sign in with Facebook")
    expect(User.all.count).to eq(1)
    expect(page).to have_content 'Successfully authenticated from Facebook account.'
    expect(page).to have_selector("a", text: "Logout")
  end

  scenario 'invalid signin' do
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
    visit root_path
    expect(page).to have_content "Sign in with Facebook"
    expect(User.all.count).to eq(0)
    click_link("Sign in with Facebook")
    expect(User.all.count).to eq(0)
    # expect(page).to have_content("Email")
    expect(page).to have_selector("a", text: "Login")
    expect(page).to have_selector("a", text: "Sign in with Facebook")
  end
end