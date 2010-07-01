require 'rubygems'
require 'sinatra'

get '/' do
  @view = "index"
  erb :index
end

get '/128' do
  @url = "http://icecast.media.berkeley.edu:8000/kalx-128.mp3.m3u"
  erb :play
end

get '/56' do
  @url = "http://icecast.media.berkeley.edu:8000/kalx-56.mp3.m3u"
  erb :play
end

get '/playlist' do
  @url = "http://kalx.berkeley.edu/last24hours.php"
  erb :play
end

__END__


@@ layout
  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
  <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <% if @view != "index" %>
      <meta http-equiv="refresh" content="0; url=<%= @url %>">
    <% end %>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="Content-Language" content="en-us" />
    <meta name = "viewport" content = "user-scalable=no, width=device-width">
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />    <title>KALX Mobile</title>
    <style type="text/css">
  		html, body {
  			height: 100%;
  			margin: 0;
  			padding: 0;
  		}
      body {
        text-align:center;
        background-color:#1a1a1a;
        font-family:arial, sans-serif;
        padding:9px;
      }
      ul, li {
  			margin: 0;
  			padding: 0;
      }
      li {
        margin-bottom:9px;
        list-style-type:none;
      }
      li a {
        display:block;
        background-color:#444;
        color:#eee;
        font-weight:bold;
        font-size:24px;
        padding:9px;
        text-decoration:none;
      }
      li a:hover {
        background-color:#555;
        color:#fff
      }
      h1 {
        font-size:100px;
        margin:0;
        padding:0;
        margin-bottom:9px;
        color:#333
      }
    </style>
  </head>
  <body>
    <%= yield %>
  </body>
  </html>

@@ index
  <h1>KALX</h1>
  <ul>
    <li>
      <a href="/128">128k</a>
    </li>
    <li>
      <a href="/56">56k</a>
    </li>
    <li>
      <a href="/playlist">Playlist</a>
    </li>
  </ul>

@@ play