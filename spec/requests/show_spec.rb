require "spec_helper"

describe 'posts', :transactional => true do

  it 'should show post when title clicked' do
    # create 2 posts
    posts= []
    (1..2).each do
      posts << Factory.create(:post)
    end
    (0..1).each do |i|
      title=  posts[i].title
      visit '/'
      click_link title
      response.should be_success
      response.should have_selector("div.post h2:contains('#{title}')")
      response.should have_selector("p:contains('#{posts[i].body}')")
      response.should have_selector("form.commentform")
    end
  end

  it "should show tag and category in index" do
    post= Factory(:tagged_post)
    visit '/'
    response.should have_selector("p.meta", :content => post.tags_csv)
    response.should have_selector("p.meta:contains('#{post.categories_csv}')")
  end
  
  it "should show tag and category in show" do
    post= Factory(:tagged_post)
    visit "/post/#{post.id}"
    response.should have_selector("p.meta:contains('#{post.tags_csv}')")
    response.should have_selector("p.meta:contains('#{post.categories_csv}')")
  end
  
end

