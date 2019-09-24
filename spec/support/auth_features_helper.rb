module AuthFeaturesHelper
  def sign_up_as(user)
    visit new_user_registration_path
    fill_in("Email", with: user.email)
    fill_in("Password", with: user.password)
    fill_in("Password confirmation", with: user.password)
    click_button("Sign up")
  end

  def log_in_as(user)
    visit new_user_session_path
    fill_in("Email", with: user.email)
    fill_in("Password", with: user.password)
    click_button("Log in")
  end
end