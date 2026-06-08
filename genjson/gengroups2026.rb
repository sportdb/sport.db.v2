##
##  to run use:
##   $ ruby gengroups2026.rb        (in /genjson)



## note: use the local version of gems
$LOAD_PATH.unshift( File.expand_path( '../parser/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../quick/lib' ))


## our own code
require 'sportdb/quick'


OPENFOOTBALL_PATH = '../../../openfootball'



SportDb::MatchParser.debug = false


def parse_groups( path, start: )
    groups = []

      puts "==> reading #{path}..."
      txt = read_text( path )

      parser = SportDb::MatchParser.new( txt, start: start )

      teams, matches, rounds, groups = parser.parse

      if parser.errors?
        puts "!! #{parser.errors.size} parse error(s) in #{path}:"
        pp parser.errors
        exit 1
      end

      groups
end



inpath = "#{OPENFOOTBALL_PATH}/worldcup/2026--usa/cup.txt"



groups = parse_groups( inpath, start: Date.new( 2026, 6, 1 ))

data = {
         'name'   => 'World Cup 2026',
         'groups' => groups.map do |group|
                                     {
                                         'name'  =>  group.name,
                                         'teams' =>  group.teams
                                      }
                                 end
       }

pp data



## outdir =   "#{OPENFOOTBALL_PATH}/worldcup.json"
outdir = './tmp-worldcup'
outpath = "#{outdir}/2026/worldcup.groups.json"
write_json( outpath, data )


puts "bye"
