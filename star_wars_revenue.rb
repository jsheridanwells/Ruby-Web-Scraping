require 'Nokogiri'
require 'rest-client'
require 'json'

# this url has got tables with the box office gross for each star wars movie
name_rev_url = 'http://www.boxofficemojo.com/franchises/chart/?id=starwars.htm'

def clean_query(query)
  clean_query = query.split(' ').map do |word|
    if word =~ /[^A-Za-z0-9]/i
      word.gsub!(/[^A-Za-z0-9]/i, '')
      word unless word.length === 0
    else
      word
    end
  end
  clean_query.delete(nil)
  clean_query.join(' ').gsub(' ', '_')
end

def score_url(query)
  "https://www.rottentomatoes.com/m/" + clean_query(query)
end

# parse all the HTML
raw_name_revenue = Nokogiri::HTML(RestClient.get(name_rev_url))
# raw_score = Nokogiri::HTML(RestClient.get(score_url('Star Wars: The Force Awakens')))
raw_score = Nokogiri::HTML(RestClient.get('https://www.rottentomatoes.com/search/?search=Star%20Wars%3A%20The%20Force%20Awakens'))
puts raw_score.css('#search-results-root')[0].next_element
# score = Nokogiri::HTML(RestClient.get(''))

# the table that is adjusted for inflation is the 0th table
# each table begins with a title with font color #8b0000
title = raw_name_revenue.css('font[color="#8b0000"]')[0]

# after the <font> with the title, the next element is the table itself
# we're grabbing all of the rows
rows = title.next_element.css('tr')

# create a hash to store all of the movei data
infos = Hash.new

# for each row starting at index 1 (because the 0th row is the column names)
# each key in infos is the name of the movie, each value is the gross revenue
for i in 1..(rows.length - 3) do
  # raw_score = Nokogiri::HTML(RestClient.get(score_url(rows[i].css('td')[1].text)))
  infos[rows[i].css('td')[1].text] = Hash.new
  infos[rows[i].css('td')[1].text][:revenue] =  rows[i].css('td')[3].text
  # infos[rows[i].css('td')[1].text][:score] = raw_score.css('.meter-value')[0].text[0,2].to_i
end

# puts infos

# write the data to a file in JSON format
# File.open('star_wars_data.json', 'w') { |f| f.write(infos.to_json) }

=begin
  JSON contents look like this....
  {  
   "Star Wars":"$1,310,298,200",
   "Star Wars: The Force Awakens":"$992,496,600",
   "Star Wars: Episode I - The Phantom Menace":"$778,700,900",
   "Return of the Jedi":"$743,427,500",
   "The Empire Strikes Back":"$723,955,300",
   "Star Wars: The Last Jedi":"$604,813,000",
   "Rogue One: A Star Wars Story":"$554,854,100",
   "Star Wars: Episode III - Revenge of the Sith":"$544,599,700",
   "Star Wars: Episode II - Attack of the Clones":"$477,472,600",
   "Star Wars (Special Edition)":"$276,515,700",
   "The Empire Strikes Back (Special Edition)":"$135,195,400",
   "Return of the Jedi (Special Edition)":"$90,940,900",
   "Star Wars: Episode I - The Phantom Menace (in 3D)":"$50,363,900",
   "Star Wars (Re-issue)":"$48,323,900",
   "Star Wars: The Clone Wars":"$44,955,900",
   "The Empire Strikes Back (Re-issue)":"$41,454,400",
   "Return of the Jedi (Re-issue)":"$29,097,000",
   "Attack of the Clones: The IMAX Experience (IMAX)":"$13,368,000"
}

=end