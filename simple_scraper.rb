require 'nokogiri'
require 'rest-client'

page = Nokogiri::HTML(RestClient.get('http://en.wikipedia.org'))

page.css('.interlanguage-link').css('a').each do |language| 
  puts language.text
end