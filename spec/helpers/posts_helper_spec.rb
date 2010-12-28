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

  describe '#categories' do
    before do
      @post= mock_model(Post)
    end
    
    it 'should have no categories' do
      @post.stub(:categories).and_return([])
      helper.categories(@post).should be_blank
    end

    it 'should have categories' do
      c1= double
      c2= double
      c1.stub(:name).and_return('cat1')
      c2.stub(:name).and_return('cat2')
      @post.stub(:categories).and_return([c1, c2])
      # <a href=\"/articles/category/cat1\">cat1</a>,<a href=\"/articles/category/cat2\">cat2</a>
      helper.categories(@post).should have_selector('a', :href => "/articles/category/cat1", :content => 'cat1')
      helper.categories(@post).should have_selector('a', :href => "/articles/category/cat2", :content => 'cat2')
    end    
  end

  describe '#tags' do
    before do
      @post= mock_model(Post)
    end
    
    it 'should have no tags' do
      @post.stub(:tags).and_return([])
      helper.tags(@post).should be_blank
    end

    it 'should have tags' do
      c1= double
      c2= double
      c1.stub(:name).and_return('tag1')
      c2.stub(:name).and_return('tag2')
      @post.stub(:tags).and_return([c1, c2])
      helper.tags(@post).should have_selector('a', :href => "/articles/tag/tag1", :content => 'tag1')
      helper.tags(@post).should have_selector('a', :href => "/articles/tag/tag2", :content => 'tag2')
    end    
  end
  

end
