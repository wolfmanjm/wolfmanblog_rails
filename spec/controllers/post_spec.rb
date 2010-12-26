require 'spec_helper'

describe PostsController do

  context "logged in" do
    before(:each) do
      @post = mock_model(Post)
      controller.stub!(:ensure_authenticated).and_return(true)
    end

    it "should be creatable" do
      title= "this is the title"
      body= "this is the body"
      cats= 'cat1,cat2'
      tags= 'tag1,tag2'
      Post.should_receive(:new).and_return(@post)
      @post.should_receive(:title=).with(title)
      @post.should_receive(:body=).with(body)
      @post.should_receive(:save)
      @post.should_receive(:update_categories_and_tags).with(cats, tags)

      post :create, :post => {:title => title, :body => body, :categories_csv => cats, :tags_csv => tags}
      response.should redirect_to(postbyid_path(@post))
    end


    it "should be deleteable" do
      Post.should_receive(:[]).with("1").and_return(@post)
      Comment.should_receive(:delete_comments_for_post).with(@post.id)
      @post.should_receive(:remove_all_tags)
      @post.should_receive(:remove_all_categories)
      @post.should_receive(:destroy)

      delete :destroy, :id => "1"
      response.should redirect_to(posts_path)
    end

    it "should be uploadable"
    it "should be updatable"
    
  end

  context "logged out" do
    it "should not be deleteable" do
      Post.should_not_receive(:[])
      Comment.should_not_receive(:delete_comments_for_post)
      
      delete :destroy, :id => "1"
      response.status.should == 401
    end

    it "should not be creatable" do
      Post.should_not_receive(:new)
      post :create
      response.status.should == 401
    end

    it "should not be uploadable" do
      post :upload
      response.status.should == 401
    end
    
    it "should not be updatable" do
      put :update, :id => "1"
      response.status.should == 401
    end
      

  end
  
end
