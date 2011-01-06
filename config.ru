# This file is used by Rack-based servers to start the application.

# if we want standalone passenger to log accesses
#require 'logger'
#class ::Logger; alias_method :write, :<<; end
#root = ::File.dirname(__FILE__)
#logfile = ::File.join(root,'log','access.log')
#logger  = ::Logger.new(logfile, 'daily')
#use Rack::CommonLogger, logger

if ENV['RACK_ENV'] == "production"
  # Setup my spammer honeypot. if we detect a known spammer url then put it in the block list
  # only runs if a redis server is running
  require 'redis'
  begin
    r= Redis.new(:thread_safe => true)
    if r.ping == 'PONG'
      require ::File.expand_path('../lib/rack/rack-spammers',  __FILE__)
      use Rack::Spammers, :cache => r, :urlmap => [ [:get, %r{\+\+GET\+http}] ]
    else
      raise "no redis ping"
    end
  rescue
    puts "[RACK] Redis server not running"
  end
end

require ::File.expand_path('../config/environment',  __FILE__)
run Wolfmanblog::Application
