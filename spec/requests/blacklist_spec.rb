require 'spec_helper'


describe 'blacklist', :transactional => true do

  before(:each) do
    @post= Factory.create(:post)
  end
  
  it 'should be left by a user with email' do
    visit "/post/#{@post.id}"
    fill_in 'comment[name]', :with => "comment user"
    fill_in 'comment[email]', :with => "comment email"
    fill_in 'comment[body]', :with => "my comment message"
    check 'no'
    click_button "Submit"
    response.should be_successful
    response.should have_selector("ol.comment-list li.comment cite strong:contains('comment user')")
    response.should have_selector("ol.comment-list li.comment:contains('my comment message')")
    @post.should have(1).comment
  end

  it 'should blacklist anyone leaving a url' do
    visit "/post/#{@post.id}"
    fill_in 'comment[name]', :with => "comment user"
    fill_in 'comment[url]', :with => "spam"
    fill_in 'comment[body]', :with => "my comment message"
    check 'no'
    click_button "Submit"
    response.should be_successful
    @post.should have(0).comment

    # TODO check redis got updated
  end

end
  
