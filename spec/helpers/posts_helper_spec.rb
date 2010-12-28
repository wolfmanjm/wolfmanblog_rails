require 'spec_helper'

describe PostsHelper do 

  before do 
    @post= mock_model(Post)
  end
  
  describe '#num_comments' do
    it "should have 10 comments" do
      @post.stub("comments_size").and_return(10)
      # <a href=\"/post/1001#comments\">10 comments</a>
      helper.num_comments(@post).should have_selector('a', :href => "/post/#{@post.id}#comments", :content => '10 comments')
    end

    it 'should have no comments' do
      @post.stub("comments_size").and_return(0)
      helper.num_comments(@post).should == 'no comments'
    end
  end
  
end
