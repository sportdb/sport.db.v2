
require_relative 'helper'



wc2022_matches_url = "https://worldcupjson.net/matches"

fetch_json( wc2022_matches_url, "./tmp/worldcupjson2022.json" )


puts "bye"