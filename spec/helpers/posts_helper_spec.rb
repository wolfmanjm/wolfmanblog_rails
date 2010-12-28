require 'spec_helper'

describe PostsHelper do 

  before do 
    @post= mock_model(Post)
  end
  
  describe '#num_comments with comments' do
    @post.stub("comments_size").and_return(10)
    helper.num_comments(@post).should == '10 comments'
  end

  describe '#num_comments with no comments' do
    @post.stub("comments_size").and_return(0)
    helper.num_comments(@post).should == 'no comments'
  end

  
  
end
