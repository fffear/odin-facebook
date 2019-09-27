require 'rails_helper'

feature "adding and accepting friend requests" do
  given(:user) { FactoryBot.create(:user) }
  given(:user_2) { FactoryBot.create(:user) }
  given(:invalid_user) { FactoryBot.build(:invalid_user) }

  scenario "sending and accepting friend requests" do
    # doesn't have "Add Friend" button on current user #show page
    navigate_to_own_show_page(user)
    expect(page).to_not have_selector "input[type=submit][value='Add Friend']"
    
    # has an "Add Friend" button on a user #show page that is not the current_user
    visit user_path(user_2.id)
    check_existence_of_add_friend_button(user_2)

    # sends a friend request when click on "Add Friend" button
    check_friend_request_sent_when_add_friend_button_clicked
    expect(page).to_not have_selector "input[type=submit][value='Add Friend']"
    expect(page).to have_content "Friend request has been sent to #{user_2.first_name}"

    # has an "Accept Friend Request" button
    click_link("Logout")
    log_in_as(user_2)
    check_existence_of_accept_friend_request_button(user)

    # becomes friends when "Accept Friend Request" button is clicked
    check_friendship_created_when_click_button("Accept Friend Request")
    expect(page).to_not have_selector "input[type=submit][value='Accept Friend Request']"
    expect(page).to have_content "Accepted friend request."

    # doesn't have an "Add Friend" button on a user #show page when already friends
    visit user_path(user_2)
    expect(page).to_not have_selector "input[type=submit][value='Add Friend']"
  end

  scenario 'canceling friend requests' do
    navigate_to_own_show_page(user)
    expect(page).to_not have_selector "input[type=submit][value='Add Friend']"
    visit user_path(user_2.id)
    check_friend_request_sent_when_add_friend_button_clicked
    expect(page).to_not have_selector "input[type=submit][value='Add Friend']"

    # requester cancels friend request when "Cancel Friend Request" button is clicked
    expect(page).to have_selector "input[type=submit][value='Cancel Friend Request']"
    check_friend_request_cancelled_when_click_button("Cancel Friend Request")

    # add friend again for further tests below
    check_existence_of_add_friend_button(user_2)
    check_friend_request_sent_when_add_friend_button_clicked

    # login as user_2
    click_link("Logout")
    log_in_as(user_2)
    expect(page).to have_selector "input[type=submit][value='Delete Request']"
    check_friend_request_cancelled_when_click_button("Delete Request")
  end

  scenario 'unfriending friends' do
    navigate_to_own_show_page(user)
    visit user_path(user_2)
    check_friend_request_sent_when_add_friend_button_clicked
    click_link("Logout")
    log_in_as(user_2)
    check_friendship_created_when_click_button("Accept Friend Request")
    visit user_path(user)
    expect(page).to have_selector("input[type=submit][value='Unfriend']")
    expect(page).to have_selector("form[action='#{friendship_path(user.specific_friendship_with(user_2))}']")
    expect(Friendship.all.count).to eq(1)
    click_button("Unfriend")
    expect(Friendship.all.count).to eq(0)
    expect(page).to have_content("#{user.first_name} unfriended.")
  end
end