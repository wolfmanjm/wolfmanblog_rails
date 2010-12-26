require 'spec_helper'

describe ApplicationHelper do
  
  describe '#permalink', :type => :transactional do    
    it 'returns the permalink of the given post' do
      post= Factory(:post)
      helper.permalink(post).should == "/articles/#{post.year}/#{post.month}/#{post.day}/#{post.permalink}"
    end
  end
  
  describe '#absolute_permalink', :type => :transactional do  
    it 'returns the absolute permalink of the given post' do
      post= Factory(:post)
      helper.absolute_permalink(post).should == "http://test.host/articles/#{post.year}/#{post.month}/#{post.day}/#{post.permalink}"
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
