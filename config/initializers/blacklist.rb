begin
  $redis= nil
  r= Redis.new(:thread_safe => true)
  if r.ping == 'PONG'
    puts "setup redis"
    $redis= r
  else
    puts "no redis found"
  end
  
rescue
  puts "no redis server found: #{$!}"
end

