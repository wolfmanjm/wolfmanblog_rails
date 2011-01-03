require 'spec_helper'

describe SidebarCell, :transactional => true do
  render_views
 
  it "should render categories" do
    Factory(:tagged_post)
    render_cell(:sidebar, :categories).should have_selector("ul#categories") do |n|
      n.should have_selector('li', :content => 'cat1')
      n.should have_selector('li', :content => 'cat2')
    end
  end

  it 'should render recent comments' do
    c= Factory(:comment)
    render_cell(:sidebar, :recent_comments).should have_selector("ul") do |n|
      n.should have_selector('li a', :href => "/post/#{c.post.id}#comment-#{c.id}", :content => "by #{c.name} on #{c.post.title}")
    end  
  end

end
