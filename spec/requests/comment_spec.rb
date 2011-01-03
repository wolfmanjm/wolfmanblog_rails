require 'spec_helper'


describe 'Comments', :transactional => true do

  before(:each) do
    @post= Factory.create(:post)
  end
  
  it 'should be left by a user' do
    visit "/post/#{@post.id}"
    fill_in 'comment[name]', :with => "comment user"
    fill_in 'comment[body]', :with => "my comment message"
    fill_in 'test', :with => "no"
    click_button "Submit"
    response.should be_successful
    response.should have_selector("ol.comment-list li.comment cite strong:contains('comment user')")
    response.should have_selector("ol.comment-list li.comment:contains('my comment message')")
    @post.should have(1).comment
  end

  it 'should reject spambots' do
    visit "/post/#{@post.id}"
    fill_in 'comment[name]', :with => "comment user"
    fill_in 'comment[body]', :with => "my comment message"
    fill_in 'test', :with => "weqwe"
    click_button "Submit"
    response.should_not be_successful
    response.should_not have_selector("ol.comment-list li.comment cite strong:contains('comment user')")
    @post.should have(0).comment
  end

  it 'should not save comment on mass attribute hack' do
    post "/comments/#{@post.id}", :comment => { :name => 'name', :body => 'body', :guid => 'bogus'}, :test => 'no'
    @post.should have(0).comment
  end

end
  
