require 'Nokogiri'
require 'rest-client'
require 'json'

franchise_hash = Hash.new

# get a list of franchises from Box Office Mojo
raw_franchises = Nokogiri::HTML(RestClient.get('http://www.boxofficemojo.com/franchises/'))

franchise_names = raw_franchises.css('td').css('b').map { |name| name.text}
franchise_urls = raw_franchises.css('td').css('a').map { |a| a['href'] }.select { |url| url =~ /chart/ }

# for each franchise, get the revenue tables for each movie

# test_urls = franchise_urls[0,5]
# tables = []

# test_urls.each do |url|
#   franchise = Nokogiri::HTML(RestClient.get('http://www.boxofficemojo.com/franchises/' + url))
#   tables.push franchise.css('font[color="#8b0000"]')[0].next_element.css('tr')
# end

franchise_names[0,5].each_with_index do |franchise, index|
  franchise_data = Nokogiri::HTML(RestClient.get('http://www.boxofficemojo.com/franchises/' + franchise_urls[index]))
  franchise_movies = franchise_data.css('font[color="#8b0000"]')[0].next_element.css('tr')
  puts franchise_movies.css('td')[1].text
  puts franchise_movies.css('td')[3].text
  sleep 2
end

# for each revenue table, create a hash with the movie name and revenue

# for each movie name hash, get the search result from rotten tomatoes

# for each rotten tomato result, get the url of the move on RT

# for each movie page on RT, get the score, add it to move hash

# write the hash to a json file