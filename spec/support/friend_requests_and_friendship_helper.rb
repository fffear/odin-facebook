

module FriendRequestsAndFriendshipHelper
  def navigate_to_own_show_page(user)
    visit new_user_session_path
    log_in_as(user)
    visit user_path(user)
  end

  def check_existence_of_add_friend_button(user)
    expect(page).to have_selector "form.button_to[action='#{friend_requests_path}']"
    expect(page).to have_selector "input[type=submit][value='Add Friend']"
    expect(page).to have_selector "input[type=hidden][name=requestee_id][value=#{user.id}]", visible: false
  end

  def check_friend_request_sent_when_add_friend_button_clicked
    expect(FriendRequest.all.count).to eq(0)
    click_button("Add Friend")
    expect(FriendRequest.all.count).to eq(1)
  end

  def check_friend_request_cancelled_when_click_button(button_text)
    expect(FriendRequest.all.count).to eq(1)
    click_button(button_text)
    expect(FriendRequest.all.count).to eq(0)
  end

  def check_existence_of_accept_friend_request_button(user)
    expect(page).to have_selector "form.button_to[action='#{friendships_path}']"
    expect(page).to have_selector "input[type=submit][value='Accept Friend Request']"
    expect(page).to have_selector "input[type=hidden][name=requester_id][value=#{user.id}]", visible: false
  end

  def check_friendship_created_when_click_button(button_text)
    expect(Friendship.all.count).to eq(0)
    expect(FriendRequest.all.count).to eq(1)
    click_button(button_text)
    expect(Friendship.all.count).to eq(1)
    expect(FriendRequest.all.count).to eq(0)
  end
end