class PostsController < ApplicationController
  before_filter :ensure_authenticated, :except => [:index, :show, :list_by_category, :list_by_tag, :show_by_id]

  after_filter :flush_cache, :only => [:create, :upload, :destroy, :update]
  caches_action :index, :show, :list_by_category, :list_by_tag, :cache_path => Proc.new { |c| c.params }, :unless => :authenticated_or_rss

  rescue_from PostsController::NotFound, :with => :record_not_found
  rescue_from PostsController::ParseError, :with => :parse_error

  def index
    page= params[:page] || 1
    @posts = Post.reverse_order(:created_at).paginate(page.to_i, 10)
    respond_to do |format|
      format.html
      format.rss
      format.atom
    end
  end

  def list_by_category
    page= params[:page] || 1
    name= params[:name]
    c= Category[:name => name]
    raise NotFound unless c
    pids = c.posts.collect{ |i| i.id}
    @posts = Post.filter(:id => pids).reverse_order(:created_at).paginate(page.to_i, 10)
    render :index
  end

  def list_by_tag
    page= params[:page] || 1
    name= params[:name]
    c= Tag[:name => name]
    raise NotFound unless c
    pids = c.posts.collect{ |i| i.id}
    @posts = Post.filter(:id => pids).reverse_order(:created_at).paginate(page.to_i, 10)
    render :index
  end

  # GET /posts/:id
  def show_by_id
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
    title= params[:title]
    @post= Post.find_by_permalink(title)
    raise NotFound unless @post
  end

  #################################################
  # privileged below this

  # GET /posts/new
  def new
    @post = Post.new
  end

  # POST /posts
  def create
    @post= Post.new
    @post.title= params[:post][:title]
    @post.body= params[:post][:body]
    begin
      @post.save
      @post.update_categories_and_tags(params[:post][:categories_csv], params[:post][:tags_csv])
      redirect_to postbyid_path(@post)
    rescue
      logger.error "create post failed: reason #{@post.errors.full_messages}, error: #{$!}"
      flash[:error] = "failed reason #{@post.errors.full_messages}, error: #{$!}"
      render :new
    end
  end

  # POST /posts/upload upload a post, check if it is new or existing and update or create accordingly
  def upload
    file_param = params[:file]
    if file_param.nil?
      redirect_to new_post_path
      return
    end

    filename = file_param.original_filename
    filedata = file_param.read
    logger.info "Uploading file #{filename}"

    begin
      @h= parse_upload(filedata)
    rescue
      logger.error("Failed to parse YAML: #{$!}")
      flash[:error] = "Failed to parse YAML: #{$!}"
      redirect_to posts_path
      return
    end

    @post= Post.find(:title => @h[:title])
    if @post.nil?
      @post= Post.new
      @post.title= @h[:title]
    end

    @post.body= @h[:body]
    @post.author= filename # actually stores the original filename
    begin
      @post.save
      @post.update_categories_and_tags(@h[:categories].join(','), @h[:tags].split(' ').join(','))
      flash[:notice] = "Uploaded OK"
      render :show
    rescue
      logger.error("Failed to save upload: #{$!} - #{@post.errors.full_messages}")
      flash[:error]= "Upload failed: #{$!} - #{@post.errors.full_messages}"
      render posts_path
    end
  end

  # GET /posts/:id/edit
  def edit
    @post = Post[params[:id]]
    raise NotFound unless @post
  end

  # PUT /posts/:id
  def update
    @post = Post[params[:id]]
    raise NotFound unless @post

    begin
      @post.update(:title => params[:post][:title], :body => params[:post][:body])
      @post.update_categories_and_tags(params[:post][:categories_csv], params[:post][:tags_csv])
      flash[:notice]= "Post updated"
      redirect_to postbyid_path(@post)
    rescue
      render :edit
    end
  end

  # DELETE /posts/:id
  def destroy
    @post = Post[params[:id]]
    raise NotFound unless @post
    begin
      Comment.delete_comments_for_post(@post.id)
      @post.remove_all_tags
      @post.remove_all_categories
      @post.destroy
      flash[:notice]= "Post deleted"
      redirect_to posts_path
    rescue
      raise NotFound
    end
  end

  private

  def parse_upload(data)
    # read documents, there are two, the first has the params, the second is the actual post
    params, body = YAML.load_stream(data).documents

    #    puts "params: #{params.inspect}"
    #    puts "body: #{body.inspect}"

    if params.nil? || params.empty? || body.nil? || body.empty?
      raise "input format is bad"
    end

    if !params.has_key?('title')
      raise "Must have a title"
    end

    if !params.has_key?('categories')
      raise "Must have categories"
    end

    { :title => params['title'], :categories => params['categories'],
      :tags => params['keywords'], :body => body}

  end

  # flushes the entire cache
  def flush_cache
    logger.debug "flushing cache"
    expire_fragment %r{.*}
  end

  def authenticated_or_rss
    session[:logged_in] || params[:format] == 'rss'
  end


  def record_not_found
    flash[:error] = "Article not found"
    redirect_to root_path
  end

  def parse_error
    render :text => "412 Precondition Failed", :status => 412
  end

end
