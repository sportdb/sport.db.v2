
require_relative 'helper'


load_env   ## use dotenv (.env)

token = ENV['FOOTBALLDATA']
## note: because of public workflow log - do NOT output token

headers = {}
headers['X-Auth-Token'] = token    if token
headers['User-Agent']   = 'ruby'
headers['Accept']       = '*/*'



BASE_URL = 'http://api.football-data.org/v4'

wc2026_matches_url = "#{BASE_URL}/competitions/WC/matches?season=2026"
cl2526_matches_url = "#{BASE_URL}/competitions/CL/matches?season=2025"


fetch_json( cl2526_matches_url, "./tmp/fbdat_cl2526.json", headers: headers )


puts "bye"