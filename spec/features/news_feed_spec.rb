require 'rails_helper'

feature 'the news_feed' do
  given(:user) { FactoryBot.create(:user) }
  given(:user_2) { FactoryBot.create(:user) }

  scenario 'creating posts and comments' do
    visit new_user_session_path
    log_in_as(user)
    visit news_feed_path
    # has a form to make a post
    expect(page).to have_selector("form[action='#{user_posts_path(user)}']")
    expect(page).to have_selector("textarea[id=post_content]")
    expect(page).to have_selector("input[type=submit][value=Post]")

    # fails to creates a post when empty
    fill_in("post_content", with: "")
    expect(Post.all.count).to eq(0)
    click_on("Post")
    expect(page).to have_selector("p", text: "Post can't be empty.")
    expect(Post.all.count).to eq(0)

    # create a post when content
    fill_in("post_content", with: "This is a test post.")
    expect(Post.all.count).to eq(0)
    click_on("Post")
    expect(page).to have_selector("p", text: "Post created.")
    expect(page).to have_selector("div", text: "This is a test post.")
    expect(Post.all.count).to eq(1)

    # has a form to add a comment about a posts
    expect(page).to have_selector("form[action='#{post_comments_path(user.posts.first)}']")
    expect(page).to have_selector("textarea[id=comment_content]")
    expect(page).to have_selector("input[type=submit][value='Add Comment']")

    # fails to create a comment when empty
    fill_in("comment_content", with: "")
    expect(Comment.all.count).to eq(0)
    click_on("Add Comment")
    expect(page).to have_selector("p", text: "Comment couldn't be created.")
    expect(Comment.all.count).to eq(0)

    # create a comment when empty
    fill_in("comment_content", with: "This is a test comment.")
    expect(Comment.all.count).to eq(0)
    click_on("Add Comment")
    expect(page).to have_selector("p", text: "Comment created.")
    expect(page).to have_selector("div", text: "This is a test comment.")
    expect(Comment.all.count).to eq(1)
  end
end