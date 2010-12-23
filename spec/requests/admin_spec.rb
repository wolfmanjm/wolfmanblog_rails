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
    visit('posts/1', :put)
    response.status.should == 401
  end
  
  it 'should not be able to create a post' do
    visit('posts', :post)
    response.status.should == 401
  end
    
  it 'should not be able to upload a post' do
    visit('posts/upload', :post)
    response.status.should == 401
  end
  
end
