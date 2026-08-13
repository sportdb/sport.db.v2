
##
##  add shared quick (export) helper / utility methods
###

module Fbtxt
  module Export

#####
## todo
##   move to  Fbtxt::Export.genjson or such
##   or use Fbtxt::Serialize/Batch or ??


##
#  usage for config
#   e.g.
#  [['1930/worldcup.json', ['worldcup/1930--uruguay/cup.txt']],
#   ['1934/worldcup.json', ['worldcup/1934--italy/cup.txt']],
#   ['2026/worldcup.json', ['worldcup/2026--usa/cup.txt',   'worldcup/2026--usa/cup_finals.txt']]]
#
# todo/check:
#   change/rename indir to sourcedir/rootdir or such - why? why not?
def self.genjson( config, outdir: '.',
                          indir: '.' )


  config.each do |outfile, infiles|

    ##  step 1
    ## collect (parse) docs
      docs = []
      infiles.each_with_index do |infile,i|
        inpath = File.join( indir, infile )

        print "==> reading"
        print " [#{i+1}/#{infiles.size}]"  if infiles.size > 1
        print " #{inpath}...\n"

        doc = Document.read( inpath )

        if doc.errors?
          puts "!! #{doc.errors.size} parse error(s) in #{inpath}:"
          pp doc.errors
          exit 1
        end

        docs << doc
      end

      data = _merge_matches( *docs )

      outpath = File.join( outdir, outfile )

    ####################
    ## hack - use pretty_inspect for json pretty print
    txtjson =  data.pretty_inspect
    txtjson = txtjson.gsub( '=>', ': ' )
    ## puts txtjson[0,100] + "..."
    ## double check for syntax errors
    json = JSON.parse( txtjson )

    ##
    ## try alternate pretty print
    ##   puts JSON.pretty_generate( data, object_nl: "\n", array_nl: "\n", indent: 2)
    ##
    ## write_json( outpath, data )

    puts "     writing to >#{outpath}<"
    puts txtjson[0,100] + "..."

    write_text( outpath, txtjson )
  end
end


def self._merge_matches( *docs )
    last_name = nil
    matches   = []

    docs.each do |doc|
      name         = doc.title

      if last_name && name != last_name
         puts "!! ERROR - league names do NOT match; cannot merge/concat - sorry"
         puts "   #{last_name} != #{name}"
         exit 1
      end

      last_name = name
      matches  += doc.matches
    end

    data = { 'name'    => last_name,
             'matches' => matches.as_json }
    data
end

end # module Export
end # module Fbtxt
