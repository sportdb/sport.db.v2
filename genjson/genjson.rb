##
##  to run use:
##   $ ruby genjson.rb        (in /genjson)


## note: use the local version of gems
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../parser/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../quick/lib' ))


## our own code
require 'sportdb/quick'


OPENFOOTBALL_PATH = '../../../openfootball'

indir = OPENFOOTBALL_PATH
outdir =   "#{OPENFOOTBALL_PATH}/worldcup.json"   
## outdir = './tmp'

config = [
  ['2026/worldcup.json', ['worldcup/2026--usa/cup.txt',   'worldcup/2026--usa/cup_finals.txt']],
  ['2022/worldcup.json', ['worldcup/2022--qatar/cup.txt', 'worldcup/2022--qatar/cup_finals.txt']],    
  ['2018/worldcup.json', ['worldcup/2018--russia/cup.txt', 'worldcup/2018--russia/cup_finals.txt']],    
  ['2014/worldcup.json', ['worldcup/2014--brazil/cup.txt', 'worldcup/2014--brazil/cup_finals.txt']],    

  ['2025/clubworldcup.json', ['club-worldcup/2025/clubworldcup.txt']],
]

pp config



## SportDb::MatchParser.debug = true
SportDb::MatchParser.debug = true
SportDb::QuickMatchReader.debug = true



config.each do |outfile, infiles|
    last_name = nil
    matches = []

    outpath = File.join( outdir, outfile )

    infiles.each do |infile|
      inpath = File.join( indir, infile )

      puts "==> reading #{inpath}..."
      txt = read_text( inpath )

      quick = SportDb::QuickMatchReader.new( txt )
      more_matches = quick.parse
      name         = quick.league_name   ## quick hack - get league+season via league_name
 
      if quick.errors?
        puts "!! #{quick.errors.size} parse error(s) in #{inpath}:"
        pp quick.errors
        exit 1
      end

      if last_name && name != last_name
         puts "!! ERROR - league names do NOT match; cannot merge/concat - sorry"
         puts "   #{last_name} != #{name}"
         exit 1
      end

      last_name = name
      matches += more_matches
    end

    puts
    puts "  try json for matches:"

    data = { 'name'    => last_name,
             'matches' => matches.map {|match| match.as_json }}
 
    ## hack - use pretty_inspect for json pretty print         
    txtjson =  data.pretty_inspect 
    puts txtjson = txtjson.gsub( '=>', ': ' )
    ## double check for syntax errors
    json = JSON.parse( txtjson )
##
## try alternate pretty print
##   puts JSON.pretty_generate( data, object_nl: "\n", array_nl: "\n", indent: 2)

    write_text( outpath, txtjson )
    # write_json( outpath, data )
end



puts "bye"