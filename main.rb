require 'rubygems'
require 'sinatra'
require 'sequel'

configure do
  DB = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://kalx.db')
end

get '/' do
  @view = "index"
  erb :index
end

get '/128' do
  redirect "http://icecast.media.berkeley.edu:8000/kalx-128.mp3.m3u"
end

get '/56' do
  redirect "http://icecast.media.berkeley.edu:8000/kalx-56.mp3.m3u"
end

get '/playlist' do
  @view = 'playlist'
  @songs = DB[:playlist].reverse_order(:played_at).limit(10)
  erb :playlist
end

__END__


@@ layout
  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
  <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
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
        padding:9px 9px 36px 9px;
      }
      h1, h2, h3, p, li, ul {
        margin:0;
        padding:0;
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
        font-size:108px;
        margin-bottom:9px;
        color:#333
      }
      h2 {
        font-size:32px;
        color:#555;
        text-transform:uppercase;
        padding-bottom:18px;
      }
      p {
        font-size:14px;
        color:#555;
        margin:0;
        padding:0;
      }
      a {
        color:#555;
        text-decoration:none;
      }
      a:hover {
        color:#777;
      }
      h1 a {
        color:#444
      }
      .track {
        background-color:#303030;
        text-align:left;
        padding:9px;
        margin-bottom:9px;
      }
      .track h3 {
        color:#fff;
        padding-bottom:4px;
      }
      .track p {
        color:#999;
      }
      .track p strong {
        color:#777;
        display:inline-block;
        width:60px;
      }
      .track .created_at {
        font-size:13px;
        padding-top:4px;
      }
      .odd {
        background-color:#393939
      }
      audio {
        margin-top:36px;
      }
    </style>
  </head>
  <body>
    <h1><a href="/">KALX</a></h1>
    <%= yield %>
  </body>
  </html>

@@ index
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
  <p>
    <a href="http://kalx.berkeley.edu/">kalx.berkeley.edu</a>
  </p>
  
@@ playlist
  <h2><a href="http://kalx.berkeley.edu/last24hours.php">Last 10 Tracks</a></h2>
  <% @songs.each do |song| %>
    <div class="track odd">
      <h3><%= song[:title] %></h3>
      <p><strong>Artist:</strong> <%= song[:artist] %><p>
      <p><strong>Album:</strong> <%= song[:album] %><p>
      <p><strong>Label:</strong> <%= song[:label] %><p>
      <p class="created_at"><%= song[:played_at].strftime("%I:%M%p on %Y.%m.%d") %></p>
    </div>
  <% end %>
