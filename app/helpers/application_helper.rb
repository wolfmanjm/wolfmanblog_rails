module ApplicationHelper
  def sidebar(name)
    #part SidebarPart => name
  end

  def permalink(post, opts={})
    article_path(post.year, post.month, post.day, post.permalink, opts)
  end

  def absolute_permalink(post)
    article_url(post.year, post.month, post.day, post.permalink)
  end

  def authenticated?
    session[:logged_in]
  end

  def delete_button(url, text, opts={})
    link_to text, url, :confirm => 'Are you sure?', :method => :delete
  end
end
