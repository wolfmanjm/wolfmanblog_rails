module PostsHelper

  def num_comments(post)
    n= post.comments_size
    if n > 0
      link_to "#{n.to_s} comments", postbyid_path(post, :anchor => 'comments')
    else
      "no comments"
    end
  end

  def categories(post)
    l= []
    a= post.categories
    a.each do |i|
      l << link_to(i.name, category_path(i.name))
    end
    l.join(',')
  end

  def tags(post)
    l= []
    a= post.tags
    a.each do |i|
      l << link_to(i.name, tag_path(i.name))
    end
    l.join(',')
  end

end
