
## note: use the local version of gems
$LOAD_PATH.unshift( File.expand_path( '../parser/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../quick/lib' ))


## our own code
require 'sportdb/quick'


OPENFOOTBALL_PATH = '../../../openfootball'



SportDb::MatchTree.debug = false
Fbtxt::Document.debug = false


def parse_matches( *infiles, indir: '.' )
    last_name = nil
    matches = []

    infiles.each do |infile|
      inpath = File.join( indir, infile )

      puts "==> reading #{inpath}..."
      txt = read_text( inpath )

      doc = Fbtxt::Document.parse( txt )
      more_matches = doc.matches
      name         = doc.title

      if doc.errors?
        puts "!! #{doc.errors.size} parse error(s) in #{inpath}:"
        pp doc.errors
        exit 1
      end

      if last_name && name != last_name
         puts "!! ERROR - league names do NOT match; cannot merge/concat - sorry"
         puts "   #{last_name} != #{name}"
         exit 1
      end

      last_name = name
      matches  += more_matches
    end

    puts
    puts "  try json for matches:"

    data = { 'name'    => last_name,
             'matches' => matches.map {|match| match.as_json }}
    data
end



def genjson( config, outdir: '.',
                     indir: '.' )

  config.each do |outfile, infiles|

    data = parse_matches( *infiles, indir: indir )

    outpath = File.join( outdir, outfile )

    ## hack - use pretty_inspect for json pretty print
    txtjson =  data.pretty_inspect
    txtjson = txtjson.gsub( '=>', ': ' )
    puts txtjson[0,100] + "..."
    ## double check for syntax errors
    json = JSON.parse( txtjson )

##
## try alternate pretty print
##   puts JSON.pretty_generate( data, object_nl: "\n", array_nl: "\n", indent: 2)

    write_text( outpath, txtjson )
    # write_json( outpath, data )
  end
end
