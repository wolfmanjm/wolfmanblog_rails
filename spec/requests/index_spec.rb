require 'spec_helper'

describe 'index page' do

  before(:each) do
    @posts= []
    # create 20 posts
    (1..20).each do
      @posts << Factory.create(:post)
    end
  end

  it 'should show page 1' do
    visit '/'
    response.should be_successful

    # make sure we can see first 10 posts
    (10..19).each do |i|
      y= @posts[i].year
      m= @posts[i].month
      d= @posts[i].day
      pl= @posts[i].permalink
      response.should have_xpath("//h2/a[@href='/articles/#{y}/#{m}/#{d}/#{pl}']['#{@posts[i].title}']")
      response.should have_selector("p:contains('#{@posts[i].body}')")
    end

    response.should_not have_selector("p:contains('#{@posts[0].body}')")
    response.should_not have_selector("p:contains('#{@posts[9].body}')")


  end

  it 'should show previous page' do
    visit '/'
    response.should be_successful
    click_link "Older posts"
    
    # make sure we can see next 10 posts
    (0..9).each do |i|
      y= @posts[i].year
      m= @posts[i].month
      d= @posts[i].day
      pl= @posts[i].permalink
      response.should have_xpath("//h2/a[@href='/articles/#{y}/#{m}/#{d}/#{pl}']['#{@posts[i].title}']")
      response.should have_selector("p:contains('#{@posts[i].body}')")
    end

    response.should_not have_selector("p:contains('#{@posts[10].body}')")
    response.should_not have_selector("p:contains('#{@posts[19].body}')")
    
  end
  
end

  
