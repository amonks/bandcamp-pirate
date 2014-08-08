gem 'pry'

require 'pry'

require 'open-uri'
require 'JSON'

puts "bandcamp url, please"
url = gets.chomp

album_id = JSON.parse(open("http://api.bandcamp.com/api/url/1/info?key=vatnajokull&url=" + url).read)["album_id"]

response = JSON.parse(open("http://api.bandcamp.com/api/album/2/info?key=vatnajokull&album_id=" + album_id.to_s).read)

urls = response['tracks'].map { |track| track['streaming_url'] }

puts urls