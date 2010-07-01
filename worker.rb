require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'sequel'

DB = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://kalx.db')
DB.create_table :playlist do
  primary_key :id
  String      :artist
  String      :title
  String      :album
  String      :label
  DateTime    :played_at
  DateTime    :created_at
end unless DB.table_exists? :playlist

while true
  puts "#{Time.now} : Fetching"

  doc = Nokogiri::HTML(open('http://kalx.berkeley.edu/last24hours.php'))
  doc.xpath('//tr').each { |row|
    time, info, artist, title, album, label = nil
    time, info = row.xpath('td').map { |td| td.text.strip }

    if !info
      $date = time
      next
    end
    
    played_at = Time.parse($date + ' ' + time)
    artist = row.xpath('td/strong').text

    next if DB[:playlist][:played_at => played_at, :artist => artist] # already saved this track, and presumably the subsequent ones

    if match = info.match(/\"([^\"]+)"/)
      title = match[1]
    end
  
    if match = info.match(/\" - (.*) \((.*)\)$/)
      album = match[1]
      label = match[2]
    end
  
    args = {:artist => artist, :title => title, :album => album, :label => label, :played_at => played_at, :created_at => Time.now}
    puts "#{played_at} : Inserting #{artist} // #{title}"
    DB[:playlist].insert(args)
  }
  
  sleep(2 * 60)
end