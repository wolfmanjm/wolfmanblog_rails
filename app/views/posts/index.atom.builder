atom_feed do |feed|
  feed.title "Wolfmans Howlings"
  feed.subtitle "A programmers Blog about Ruby, Rails and a few other issue"
  feed.updated @posts.first.created_at
  
  for post in @posts
    feed.entry(post, :url => absolute_permalink(post)) do |entry|
      entry.title post.title
      entry.content post.to_html, :type => 'html'
      entry.author do |author|
        author.name "Jim Morris"
      end
    end
  end
end