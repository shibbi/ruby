require 'webrick'

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html

server = WEBrick::HTTPServer.new(Port: 3000)

server.mount_proc('/') do |req, res|
  res.content_type = 'text/text'
  res.body = "You requested this sub-path: #{req.path}"
end

# server.mount_proc('/shibbi') do |req, res|
#   res.status = 302
#   res['location'] = 'http://shibofang.tumblr.com/'
# end

trap('INT') { server.shutdown }

server.start
