# This file is used by Rack-based servers to start the application.

# if we want standalone passenger to log accesses
#require 'logger'
#class ::Logger; alias_method :write, :<<; end
#root = ::File.dirname(__FILE__)
#logfile = ::File.join(root,'log','access.log')
#logger  = ::Logger.new(logfile, 'daily')
#use Rack::CommonLogger, logger

require ::File.expand_path('../config/environment',  __FILE__)
run Wolfmanblog::Application
