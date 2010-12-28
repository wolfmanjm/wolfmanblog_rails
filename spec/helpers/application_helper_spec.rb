require 'spec_helper'

describe ApplicationHelper do

  before do
    @post= mock_model(Post)
    @post.stub(:year).and_return('2010')
    @post.stub(:month).and_return('11')
    @post.stub(:day).and_return('21')
    @post.stub(:permalink).and_return('a-permalink')
  end

  describe '#permalink' do    
    it 'returns the permalink of the given post' do
      helper.permalink(@post).should == "/articles/2010/11/21/a-permalink"
    end
  end
  
  describe '#absolute_permalink' do  
    it 'returns the absolute permalink of the given post' do
      helper.absolute_permalink(@post).should == "http://test.host/articles/2010/11/21/a-permalink"
    end
  end

  describe '#authenticated?' do   
    it 'returns true if logged in ' do
      helper.session[:logged_in]= true
      helper.authenticated?.should be_true
    end

    it 'returns false if not logged in ' do
      helper.authenticated?.should be_false
    end
  end

  describe '#format_comment' do
    it 'return sanitized input' do
      helper.format_comment("<p> hello\n  there\n</p>").should == "&lt;p&gt; hello<br />\n&nbsp;&nbsp;there<br />\n&lt;/p&gt;"
    end
  end
  
end
