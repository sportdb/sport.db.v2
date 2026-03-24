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
## outdir =   "#{OPENFOOTBALL_PATH}/worldcup.json"   
## outdir =   "#{OPENFOOTBALL_PATH}/euro.json"   
outdir = './tmp'

=begin
config = [
  ['2020/euro.json', ['euro/2021--europe/euro.txt']],
  ['2024/euro.json', ['euro/2024--germany/euro.txt']],    
  ['2028/euro.json', ['euro/2028--united_kingdom-ireland/euro.txt']],    
]


config = [
  ['2025/clubworldcup.json', ['club-worldcup/2025/clubworldcup.txt']],
]

=end

config = [

  ['1930/worldcup.json', ['worldcup/1930--uruguay/cup.txt']],
  ['1934/worldcup.json', ['worldcup/1934--italy/cup.txt']],
  ['1938/worldcup.json', ['worldcup/1938--france/cup.txt']],
  
  ['1950/worldcup.json', ['worldcup/1950--brazil/cup.txt']],
  ['1954/worldcup.json', ['worldcup/1954--switzerland/cup.txt']],
  ['1958/worldcup.json', ['worldcup/1958--sweden/cup.txt']],
  ['1962/worldcup.json', ['worldcup/1962--chile/cup.txt']],
  ['1966/worldcup.json', ['worldcup/1966--england/cup.txt']],
  ['1970/worldcup.json', ['worldcup/1970--mexico/cup.txt']],
  ['1974/worldcup.json', ['worldcup/1974--west-germany/cup.txt']],
  ['1978/worldcup.json', ['worldcup/1978--argentina/cup.txt']],
  ['1982/worldcup.json', ['worldcup/1982--spain/cup.txt']],
  ['1986/worldcup.json', ['worldcup/1986--mexico/cup.txt', 'worldcup/1986--mexico/cup_finals.txt']],
  ['1990/worldcup.json', ['worldcup/1990--italy/cup.txt', 'worldcup/1990--italy/cup_finals.txt']],
  ['1994/worldcup.json', ['worldcup/1994--usa/cup.txt', 'worldcup/1994--usa/cup_finals.txt']],
  ['1998/worldcup.json', ['worldcup/1998--france/cup.txt', 'worldcup/1998--france/cup_finals.txt']],
  ['2002/worldcup.json', ['worldcup/2002--south-korea-n-japan/cup.txt', 'worldcup/2002--south-korea-n-japan/cup_finals.txt']],
  ['2006/worldcup.json', ['worldcup/2006--germany/cup.txt', 'worldcup/2006--germany/cup_finals.txt']],
  ['2010/worldcup.json', ['worldcup/2010--south-africa/cup.txt', 'worldcup/2010--south-africa/cup_finals.txt']],

  ['2014/worldcup.json', ['worldcup/2014--brazil/cup.txt', 'worldcup/2014--brazil/cup_finals.txt']],    
  ['2018/worldcup.json', ['worldcup/2018--russia/cup.txt', 'worldcup/2018--russia/cup_finals.txt']],    
  ['2022/worldcup.json', ['worldcup/2022--qatar/cup.txt', 'worldcup/2022--qatar/cup_finals.txt']],    
=begin
  ['2026/worldcup.json',                ['worldcup/2026--usa/cup.txt',   'worldcup/2026--usa/cup_finals.txt']],
  ['2026/worldcup.quali_playoffs.json', ['worldcup/2026--usa/quali_playoffs.txt']],
=end
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