require 'spec_helper'

describe Post do

  context 'valid posts' do
    before do
      @p1= Factory(:post)
      @p2= Factory(:post)
      @p3= Factory(:post, :body => "line 1\nline 2\n\nline 3\nline 4\n\nline 5\nline 6")
    end

    it "should get next post" do
      @p1.next_post.should == @p2
    end
    
    it "should get previous post" do
      @p2.previous_post.should == @p1
    end

    it "should have abstract" do
      @p3.abstract.should match("<p>line 1\nline 2</p>\n\n<p>line 3\nline 4</p>\n")
      @p3.abstract.should_not match("line [56]")
    end
    
    
  end
  
end
