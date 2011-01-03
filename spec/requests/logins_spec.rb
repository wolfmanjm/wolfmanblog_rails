require 'spec_helper'

describe "Logins", :transactional => true do
  
  it "should allow valid login" do
    user= Factory(:user)
    visit "/login"
    response.should be_successful
    nonce= response.body.match(/nonce.*value=\"([^"]+)\"/)[1]
    cp= user.crypted_password
    sha1 = Digest::SHA1.hexdigest("#{cp}-#{nonce}")
    fill_in 'login', :with => user.name
    fill_in 'password', :with => sha1
    click_button 'Log in'
    response.should be_successful
    response.should have_xpath("//*[@class='logged-in']")
    response_body.should match(/logged in as admin/i)
  end

  it 'should fail invalid login' do
    user= Factory(:user)
    visit "/login"
    response.should be_successful
    fill_in 'login', :with => user.name
    fill_in 'password', :with => "not the right thing"
    click_button 'Log in'
    response.should be_successful
    response.should_not have_xpath("//*[@class='logged-in']")
  end
  
end
