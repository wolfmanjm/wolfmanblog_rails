require 'spec_helper'

describe Post do

  context 'valid' do
    before do
      @p1= Factory(:post)
      @p2= Factory(:post)
      @p3= Factory(:post, :body => "line 1\nline 2\n\nline 3\nline 4\n\nline 5\nline 6")
      @pl1= @p1.title.split(' ').join('-')
      @pl2= @p2.title.split(' ').join('-')
    end

    it "should have permalink" do
      @p1.permalink.should == @pl1
      @p2.permalink.should == @pl2
    end
      
    it "should have guid" do
      @p1.guid.should_not be_blank
      @p2.guid.should_not be_blank
    end

    it 'should find by permalink' do
      Post.find_by_permalink(@pl1).should == @p1
      Post.find_by_permalink(@pl2).should == @p2
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

    it 'should be valid' do
      @p1.should be_valid
      @p2.should be_valid
    end

    it 'should have no comments' do
      @p1.should have(0).comments
      @p1.comments_size.should == 0
    end

    it 'should have no tags' do
      @p1.should have(0).tags
      @p1.tags_csv.should be_empty
    end

    it 'should have no categories' do
      @p1.should have(0).categories
      @p1.categories_csv.should be_empty
    end

    it 'should update categories and tags' do
      @p1.update_categories_and_tags('c1,c2,c3', 't1,t2')
      @p1.should have(3).categories
      @p1.categories_csv.should == 'c1,c2,c3'
      @p1.should have(2).tags
      @p1.tags_csv.should == 't1,t2'
    end
  end

  context 'invalid' do
    
    it 'should not be valid if title blank' do
      @p1= Factory.build(:post, :title => "")
      @p1.should_not be_valid
    end
    
    it 'should not be valid if body blank' do
      @p1= Factory.build(:post, :body => "")
      @p1.should_not be_valid
    end
    
  end

  context 'with comments' do
    before do
      @comment= Factory(:comment)
      @p1= @comment.post
    end

    it 'should have 1 comment' do
      @p1.should have(1).comments
      @p1.comments_size.should == 1
    end

    it 'should have a comment' do
      @p1.comments.first.should == @comment
    end
  end
  
  context 'with tags and categories' do

    before do
      @p1= Factory(:tagged_post)
    end
    
    it 'should have tags' do
      @p1.should have(2).tags
      @p1.tags_csv.should == "tag1,tag2"
    end
    
    it 'should have categories' do
      @p1.should have(2).categories
      @p1.categories_csv.should == "cat1,cat2"
    end

    it 'should update categories and tags' do
      @p1.update_categories_and_tags('c1,c2,c3', 't1,t2')
      @p1.should have(3).categories
      @p1.categories_csv.should == 'c1,c2,c3'
      @p1.should have(2).tags
      @p1.tags_csv.should == 't1,t2'
    end

  end
  
end
