require 'rails_helper'

feature "users index page" do
  given(:friendship) { FactoryBot.create(:friendship) }
  given(:user_1) { friendship.requester }
  given(:user_2) { friendship.requestee }
  background(:each) do
    user_3 = FactoryBot.create(:user, first_name: "Testone", last_name: "Userone")
    user_4 = FactoryBot.create(:user)
    user_5 = FactoryBot.create(:user)
    user_6 = FactoryBot.create(:user)
    FactoryBot.create(:friendship, requester: user_6, requestee: user_1)
    FactoryBot.create(:friend_request, requester: user_4, requestee: user_1)
    FactoryBot.create(:friend_request, requester: user_1, requestee: user_5)
  end

  scenario 'has a list of user that are not friends with current_user' do
    # content of users page
    log_in_as(user_1)
    visit users_path
    expect(User.not_friends_with(user_1).count).to eq(1)
    User.not_friends_with(user_1).each do |user|
      expect(page).to have_content user.full_name
      expect(page).to have_selector("input[type=hidden][value=#{user.id}]", visible: false)
    end
    expect(page).to have_selector("input[type=submit][value='Add Friend']", count: 1)
    click_button("Add Friend")
    expect(page).to have_content("Friend request has been sent to")
    expect(page).to_not have_selector("input[type=submit][value='Add Friend']")
  end
end