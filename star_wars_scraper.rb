require 'Nokogiri'
require 'rest-client'

url = 'http://www.boxofficemojo.com/franchises/chart/?id=starwars.htm'

page = Nokogiri::HTML(RestClient.get(url))
title = page.css('font[color="#8b0000"]')[0]
rows = title.next_element.css('tr')

infos = Hash.new

for i in 1..(rows.length - 3) do
  infos[rows[i].css('td')[1].text] = rows[i].css('td')[3].text
end

puts infos

# puts table.css('tr')[1].css('td')[1].text
# puts table.css('tr')[1].css('td')[3].text
# infos[rows[i].css('td')[1].text] = rows[i].css('td')[3].text