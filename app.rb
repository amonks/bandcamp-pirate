require 'bundler'
Bundler.require

require 'open-uri'
require 'json'

def errorPage(message, code)
	# redirect '/'
	status code
	@error = message
	slim :index
end

get '/' do
	@error = false
	slim :index
end

get '/*' do
	# get url
	url = params[:splat].join.gsub(':/', '://').to_s

	# request album id from url
	album_id = JSON.parse(open("http://api.bandcamp.com/api/url/1/info?key=vatnajokull&url=" + url).read)["album_id"]

	# throw error if no album id is returned
	halt errorPage("It doesn't seem like [`#{url}`](#{url}) is a real bandcamp album url", 404) unless album_id

	# get urls
	response = JSON.parse(open("http://api.bandcamp.com/api/album/2/info?key=vatnajokull&album_id=" + album_id.to_s).read)

	halt errorPage("It doesn't seem like [`#{url}`](#{url}) has any tracks", 404) unless response['tracks'].first

	@urls = {}
	response['tracks'].each { |track| @urls[track['title']] = track['streaming_url'] }

	slim :index
end

