class PostsController < ApplicationController

  before_filter :ensure_authenticated, :except => [:index, :show, :list_by_category, :list_by_tag, :show_by_id]

  #after :flush_cache, :only => [:create, :upload, :destroy]
  #cache [:index, :show, :list_by_category, :list_by_tag], { :unless => :authenticated_or_rss }

  rescue_from PostsController::NotFound, :with => :record_not_found

  def index
    #provides :rss
    page= params[:page] || 1
    @posts = Post.reverse_order(:created_at).paginate(page.to_i, 4)
  end

  def list_by_category
    page= params[:page] || 1
    name= params[:name]
    c= Category[:name => name]
    raise NotFound unless c
    pids = c.posts.collect{ |i| i.id}
    @posts = Post.filter(:id => pids).reverse_order(:created_at).paginate(page.to_i, 4)
    render :action => 'index'
  end

  def list_by_tag
    page= params[:page] || 1
    name= params[:name]
    c= Tag[:name => name]
    raise NotFound unless c
    pids = c.posts.collect{ |i| i.id}
    @posts = Post.filter(:id => pids).reverse_order(:created_at).paginate(page.to_i, 4)
    render :action => 'index'
  end

  # GET /posts/:id
  def show_by_id
    #provides :rss
    id= params[:id]
    # this protects against spambots sending in 101#blahblah
    raise NotFound unless id =~ /^\d+$/
    @post = Post[id]
    raise NotFound unless @post
    if content_type == :rss
      opts= { :format => :rss }
    else
      opts= { }
    end

    # TODO Should be a global helper called permalink
    redirect_to article_path(@post.year, @post.month, @post.day, @post.permalink, opts)

  end

  # GET /articles/:year/:month/:day/:permalink
  def show
    #provides :rss
    title= params[:title]
    @post= Post.find_by_permalink(title)
    raise NotFound unless @post
  end

  def delete
    # TODO fix this
    flash[:notice]= "destroyed"
    redirect_to root_path
  end

  def logout
    session[:logout_requested] = true
    session[:logged_in]= nil
    flash[:notice] = "You have logged out successfully"
    redirect_to(root_path)
  end

  private

  def record_not_found
    flash[:error] = "Article not found"
    redirect_to root_path
  end

end
