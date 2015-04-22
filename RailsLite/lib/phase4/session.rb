require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      req.cookies.each do |cookie|
        if cookie.name == '_rails_lite_app'
          @cookies = JSON.parse(cookie.value)
        end
      end
      @cookies ||= {}
    end

    def [](key)
      @cookies[key]
    end

    def []=(key, val)
      @cookies[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      cookie = WEBrick::Cookie.new('_rails_lite_app', @cookies.to_json)
      res.cookies << cookie
    end
  end
end
