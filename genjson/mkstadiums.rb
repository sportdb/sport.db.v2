
require 'cocos'


datasets = {
   2026 => '2026--usa/cup_stadiums.csv',
   2022 => '2022--qatar/cup_stadiums.csv',
   2018 => '2018--russia/cup_stadiums.csv',
   2014 => '2014--brazil/cup_stadiums.csv',
}


datasets.each do |year, path|
  rows = read_csv( "../openfootball/worldcup/#{path}")

  rows = rows.map do |row|
                           ## make cap into a number
                           row['capacity'] = row['capacity'].to_i(10)
                           ## delete wikipedia & wikidata for now (keep it simple)
                           row.delete('wikipedia')
                           row.delete('wikidata')
                           row
                  end
  pp rows

  data = {
    'name' => "World Cup #{year}",
    'stadiums' => rows
  }


  write_json( "../openfootball/worldcup.json/#{year}/worldcup.stadiums.json", data )
end


puts "bye"