require "ipaddr"

module Rack

  ##
  # Rack middleware for detecting blog spammers and blocking their IP addresses
  #
  #
  # === Options:
  #
  #   urlmap      url patterns to detect as spammers its [:post, regex]
  #   cache       cache store that responds to #get/#set
  #
  # === Examples:
  #
  #  use Rack::Spammers, urlmap => [[:post, %r{/article/\d+/\d+/\d+/.+/comments/\d+}], [:get, %r{/article/comment/\d+}] ], cache => Redis.new
  #
  #

  class Spammers
    attr_reader :options

    def initialize(app, options = { })
      @app = app
      @mapping = options[:urlmap] || raise('need a url map')
      @blocked_ips= options[:cache] || raise('need a store')
    end

    def call(env)
      req = Request.new(env)
      
      # see if already blocked
      return forbidden! if ip_blocked?(req.ip)

      # see if a spambot request
      @mapping.each do |m|
        if req.request_method == m[0].to_s.upcase && req.path_info =~ m[1]
          @blocked_ips.set req.ip.to_s, true
          return forbidden!
        end
      end

      # its OK
      status, headers, body = @app.call(env)
      [status, headers, body]
    end

    def forbidden!
      [200, { 'Content-Type' => 'text/html', 'Content-Length' => '0' }, []]
    end

    def ip_blocked?(ip)
      return false if ip.nil?
      !@blocked_ips.get(ip.to_s).nil?
    end

  end
end

