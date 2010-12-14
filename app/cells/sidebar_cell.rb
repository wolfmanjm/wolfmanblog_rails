class SidebarCell < Cell::Rails

  def syndicate
    render
  end

  def google_search
    render
  end

  def contact
    render
  end

  def links
    render
  end

  def categories
    @categories= Category.eager(:posts).all
    render
  end

  def tags
    tags= Tag.find_all_with_article_counters(20)
    total= tags.inject(0) {|total,tag| total += tag[:article_counter] }
    average = total.to_f / tags.size.to_f
    sizes = tags.inject({}) {|h,tag| h[tag[:name]] = (tag[:article_counter].to_f / average); h} # create a percentage
    # apply a lower limit of 50% and an upper limit of 200%
    sizes.each {|tag,size| sizes[tag] = [[2.0/3.0, size].max, 2].min * 100}

    @tags= []
    tags.sort{|x,y| x[:name] <=> y[:name]}.each do |tag|
      name= tag[:name]
      @tags << {:size => sizes[name], :name => name}
    end

    render
  end

  def recent_comments
    @comments= Comment.limit(10).order(:created_at.desc).eager(:post).all
    render
  end

  def index_of_posts
    @index_of_posts= Post.order(:title).all
    render
  end

  def recent_posts
    @index_of_posts= Post.reverse_order(:created_at).all
    render
  end

  def ads
    render
  end

  def statics
    @statics= Static.order(:position).all
    render
  end

end
