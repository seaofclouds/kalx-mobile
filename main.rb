require 'rubygems'
require 'sinatra'
require 'sequel'
require 'uri'

configure do
  DB = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://kalx.db')
end

get '/' do
  @view = "index"
  @songs = DB[:playlist].reverse_order(:played_at).limit(1)
  erb :index
end

get '/128' do
  redirect "http://icecast.media.berkeley.edu:8000/kalx-128.mp3.m3u"
end

get '/56' do
  redirect "http://icecast.media.berkeley.edu:8000/kalx-56.mp3.m3u"
end

get '/playlist/:limit' do
  @view = 'playlist'
  @songs = DB[:playlist].reverse_order(:played_at).limit(params[:limit])
  erb :playlist
end

get '/playlist' do
  redirect "/playlist/10"
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
        background-color:#444;
        font-weight:bold;
        color:#aaa;
        font-size:24px;
      }
      li.bitrate a {
        display:block;
        background-color:#444;
        color:#eee;
        padding:9px;
        text-decoration:none;
      }
      li.bitrate a span {
        color:#aaa
      }
      li.bitrate a:hover {
        background-color:#555;
        color:#fff
      }
      h1 {
        font-size:108px;
        margin: 0; padding: 0;
        line-height:108px;
        color:#333
      }
      h2 {
        font-size:26px;
        color:#555;
        text-transform:uppercase;
        padding-bottom:18px;
      }
      p {
        font-size:14px;
        color:#555;
        margin:0;
        padding:0;
        font-weight:normal;
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
      .micbreak {
        opacity:.5
      }
      .track {
        background-color:#303030;
        text-align:left;
        padding:9px;
        margin-bottom:9px;
      }
      .track h3, .track h3 a {
        color:#fff;
        padding-bottom:4px;
      }
      .track p, .track p a {
        color:#999;
      }
      .track p strong {
        color:#777;
        display:inline-block;
        width:60px;
      }
      .track .created_at {
        padding-top:4px;
        color:#777
      }
      .odd {
        background-color:#393939
      }
      audio {
        margin-top:36px;
      }
      #latest {
        margin-bottom:9px;
      }
      #latest .track {
        margin-bottom:0;
      }
      p.tracklist {
        background-color:#292929;
        font-size:16px;
        font-weight:bold;
      }
      p.tracklist a {
        display:inline-block;
        padding:9px;
        color:#eee;
      }
      p.tracklist a:hover {
        color:#fff;
        background-color:#555
      }
    </style>
  </head>
  <body>
    <h1><a href="/">KALX</a></h1>
    <%= yield %>
    <p>
      <a href="http://kalx.berkeley.edu/">berkeley kalx</a> | <a href="http://heroku.com">deployed to heroku</a> | <a href="http://github.com/seaofclouds/kalx-mobile">code on github</a> | by <a href="http://noah.heroku.com">noah</a> and <a href="http://seaofclouds.com">seaofclouds</a>
    </p>
  </body>
  </html>

@@ index
  <div id="latest">
    <% @songs.each do |song| %>
      <% if song[:title] == 'mic Break' %>
        <div class="track micbreak">
          <h3><%= song[:title] %></h3>
          <p><%= song[:artist] %></p>
          <p class="created_at"><strong><%= song[:played_at].strftime("%I:%M%p") %></strong> on <%= song[:played_at].strftime("%Y.%m.%d") %></p>
        </div>
      <% else %>
        <div class="track">
          <h3><%= song[:title] %></h3>
          <p><strong>Artist:</strong> <%= song[:artist] %></p>
          <p><strong>Album:</strong> <%= song[:album] %></p>
          <p><strong>Label:</strong> <%= song[:label] %></p>
          <p class="created_at"><%= song[:played_at].strftime("%I:%M%p on %Y.%m.%d") %></p>
        </div>
      <% end %>
    <% end %>
    <p class="tracklist">
      Recent <a href="/playlist/10">10</a> <a href="/playlist/20">20</a> <a href="/playlist/100">100</a> Tracks
    </p>
  </div>

  <ul>
    <li class="bitrate">
      <a href="/128"><span>Play</span> 128k</a>
    </li>
    <li class="bitrate">
      <a href="/56"><span>Play</span> 56k</a>
    </li>
  </ul>
  
@@ playlist
  <h2>Recent <%= params[:limit] %> Tracks</h2>
  <% @songs.each do |song| %>
    <% if song[:title] == 'mic Break' %>
      <div class="track micbreak">
        <h3><%= song[:title] %></h3>
        <p><%= song[:artist] %></p>
        <p class="created_at"><strong><%= song[:played_at].strftime("%I:%M%p") %></strong> on <%= song[:played_at].strftime("%Y.%m.%d") %></p>
      </div>
    <% else %>
      <div class="track odd">
        <h3><%= song[:title] %></h3>
        <p><strong>Artist:</strong> <%= song[:artist] %></p>
        <p><strong>Album:</strong> <%= song[:album] %></p>
        <p><strong>Label:</strong> <%= song[:label] %></p>
        <p class="created_at"><%= song[:played_at].strftime("%I:%M%p on %Y.%m.%d") %></p>
      </div>
    <% end %>
  <% end %>
  <p><small>Cached every 10min</small></p>
  <p>&nbsp;</p>
