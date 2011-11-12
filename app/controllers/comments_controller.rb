include Blacklist
class CommentsController < ApplicationController

  before_filter :ensure_authenticated, :except => [:index, :create]

  # POST /comments adds a comment to the given post
  def create

    unless params[:comment][:url].blank?
      # this is spam if it is filled out
      add_to_blacklist(request)
      redirect_to root_path
      return     
    end

    if params[:no] != '1' || params[:yes]
      #logger.error "spam comment: #{params.inspect}"
      #redirect_to root_path
      render :text => "SpamBots are not welcome", :status => 401
      return
    end

    
    @post= Post[params[:postid]]
    if @post.nil?
      logger.error "post #{params[:postid]} not found for comment"
      redirect_to root_path
      return
    end

    @comment = Comment.new
    begin
      @comment.set_only(params[:comment], :body, :name, :email, :url)
      @post.add_comment(@comment)
      flush_cache
    rescue
      logger.error "failed to add comment reason: #{@comment.errors.full_messages} - #{@post.errors.full_messages}, error: #{$!}"
    end
    redirect_to postbyid_path(@post, :anchor => 'comments')
  end

  def destroy
    id= params[:commentid]
    comment= Comment[id]
    post= comment.post
    comment.destroy
    flush_cache
    redirect_to list_comments_path, :notice => 'comment deleted'
  end

  def index
    @comments= Comment.reverse_order(:created_at).limit(10).eager(:post).all
  end

  def list
    @comments= Comment.reverse_order(:created_at).limit(20).all
  end

  private

  def flush_cache
    # TODO try to flush just the affected article
    logger.debug "flushing cache for new comment"
    expire_fragment %r{.*}
  end
end
