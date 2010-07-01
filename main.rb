require 'rubygems'
require 'sinatra'

get '/' do
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

__END__

@@ index
  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
  <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="Content-Language" content="en-us" />
    <title>KALX Mobile</title>
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
        font-size:128px;
        margin:0;
        padding:0;
        margin-bottom:9px;
        color:#333
      }
    </style>
  </head>
  <body>
    <h1>KALX</h1>
    <ul>
      <li>
        <a href="http://icecast.media.berkeley.edu:8000/kalx-128.mp3.m3u">128k</a>
      </li>
      <li>
        <a href="http://icecast.media.berkeley.edu:8000/kalx-56.mp3.m3u">56k</a>
      </li>
      <li>
        <a href="http://kalx.berkeley.edu/last24hours.php">Last 24 Hours</a>
      </li>
    </ul>
  </body>
  </html>
  
@@ play
  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
  <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="Content-Language" content="en-us" />
    <meta http-equiv="refresh" content="60; url=<%= @url %>">
    <title>KALX Mobile</title>
    <style type="text/css">
      body {
        background-color:#1a1a1a;
      }
    </style>
  </head>
  <body>
  </body>
  </html>