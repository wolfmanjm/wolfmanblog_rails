require 'spec_helper'

describe "Admin operations when not admin" do
  
  it 'should not be able to delete a post' do
    visit('posts/1', :delete)
    response.status.should == 401
  end
  
  it 'should not be able to delete a comment' do
    visit('comments/1', :delete)
    response.status.should == 401
  end
  
  it 'should not be able to edit a post' do
    visit('posts/1', :put, {:body => 'asasa'})
    response.status.should == 401
  end
  
  it 'should not be able to create a post' do
    visit('posts', :post, {:body => 'asasa'})
    response.status.should == 401
  end
    
  it 'should not be able to upload a post' do
    visit('posts/upload', :post)
    response.status.should == 401
  end
  
end

describe 'Admin operation when admin', :transactional => true do
  
  def login(user)
    visit "/login"
    response.should be_successful
    nonce= response.body.match(/nonce.*value=\"([^"]+)\"/)[1]
    cp= user.crypted_password
    sha1 = Digest::SHA1.hexdigest("#{cp}-#{nonce}")
    fill_in 'login', :with => user.name
    fill_in 'password', :with => sha1
    click_button 'Log in'
    response.should be_successful
  end
  
  it 'should be able to delete comment' do
    comment= Factory(:comment)
    post= comment.post
    user= Factory(:user)
    login(user)
    visit("comments/#{comment.id}", :delete)
    response.should be_successful
    response.should_not have_selector("ol.comment-list li.comment:contains('#{comment.body}')")
    post.should have(0).comments
  end
  
end

