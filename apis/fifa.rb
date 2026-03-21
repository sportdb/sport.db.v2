
require_relative 'helper'



BASE_URL = 'https://api.fifa.com/api/v3'


fifa2022_matches_url = "#{BASE_URL}/calendar/matches?count=500&idSeason=255711&language=en"
fifa2022_stages_url  = "#{BASE_URL}/stages?idSeason=255711&language=en"

fifa2026_matches_url = "#{BASE_URL}/calendar/matches?count=500&idSeason=285023&language=en"
fifa2026_stages_url  = "#{BASE_URL}/stages?idSeason=285023&language=en"

## fetch_json( fifa2022_matches_url, "./fifa2022.json" )

## fetch_json( fifa2026_matches_url, "./fifa2026.json" )
## fetch_json( fifa2022_stages_url, "./fifa2022_stages.json" )

premierleague_2526 = '51r6ph2woavlbbpk8f29nynf8'
pl2526_matches_url = "#{BASE_URL}/calendar/matches?count=500&idSeason=#{premierleague_2526}&language=en"

cl_2526 = '2mr0u0l78k2gdsm79q56tb2fo'
cl_2526_matches_url = "#{BASE_URL}/calendar/matches?count=500&idSeason=#{cl_2526}&language=en"


fetch_json( cl_2526_matches_ur,  "./tmp/cl_2526.json" )


puts "bye"