

require_relative 'helper'


BASE_URL = 'https://api.openligadb.de'


bl2526_matches_url  = "#{BASE_URL}/getmatchdata/bl1/2025"
bl2425_matches_url  = "#{BASE_URL}/getmatchdata/bl1/2024"
dfb2425_matches_url = "#{BASE_URL}/getmatchdata/dfb/2025"
cl2425_matches_url  = "#{BASE_URL}/getmatchdata/ucl/2025"

# fetch_json( bl2425_matches_url, "./openliga_bl2425.json" )
# fetch_json( dfb2425_matches_url, "./openliga_dfb2425_20260321.json" )
fetch_json( cl2425_matches_url, "./tmp/openliga_cl2425_20260321.json" )

puts "bye"