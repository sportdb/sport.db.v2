

## rename to   MkPages for module - why? why not?
module Pages


def self.main( args=ARGV )
##
##  add -j/--json generation option - why? why not?

 opts = {
   outdir:     './_site',
   rootdir:    '/sports/openfootball/england',
   index:      false,
   baseurl:    nil,
 }



  parser = OptionParser.new do |parser|
    parser.banner = "Usage: #{$PROGRAM_NAME} [options] <dir globs>"

     parser.on( "--outdir DIR",
                 "output dir(ectory) for generated html pages (default: #{opts[:outdir]})" ) do |outdir|
       opts[:outdir] = outdir
     end
     parser.on( "--rootdir DIR",
                 "root (& working) dir(ectory) for collecting source txt pages (default: #{opts[:rootdir]})" ) do |rootdir|
       opts[:rootdir] = rootdir
     end

     parser.on( "--baseurl URL",
                 "(github) baseurl for view/edit link, .txt and more (default: #{opts[:baseurl]})" ) do |baseurl|
       opts[:baseurl] = baseurl
     end



     parser.on( "--index",
                 "turn on index page generation (default: #{opts[:index]})" ) do |index|
       opts[:index] = true
     end
  end

  parser.parse!( args )


puts "OPTS:"
pp opts


rootdir = opts[:rootdir]
outdir  = opts[:outdir]
baseurl = opts[:baseurl]

### note - auto-excludes .edits.txt
##           e.g. braz2024.edits.txt.
files =   Fbtxt::Pathspec.find( rootdir )
puts "    #{files.size} source .txt file(s) found"


site = SiteIndex.build( files, dir:     rootdir,
                               baseurl: baseurl )


build_index( site, outdir: outdir )
exit 1

build_pages( site, outdir: outdir )

## write out sitewide stylesheet (style.css)
build_style( outdir: outdir )


end  # method self.main




def self.build_pages( site, outdir: )
    ## todo/check - why each_page.with_index is not working??)
    site.each_page_with_index do |page,i|

      outpath = "#{outdir}/#{page.outpath('.html')}"
      puts "==> [#{i+1}/#{site.size}] building page #{outpath} (#{page.relpath}/#{page.basename}.txt)..."

      html = build_page( page )

      write_text( outpath, html )



      ###
      ## generate json
      doc = Fbtxt::Document.parse( page.text )

      if doc.errors?
        puts "!! ERROR  -  #{doc.errors.size} parse error(s):"
        pp doc.errors
        exit 1
      end

      data = { 'name'    => doc.title,
               'matches' => doc.matches.as_json }

      ####################
      ## hack - use pretty_inspect for json pretty print
      txtjson =  data.pretty_inspect
      txtjson = txtjson.gsub( '=>', ': ' )
      ## puts txtjson[0,100] + "..."
      ## double check for syntax errors
      json = JSON.parse( txtjson )

      outpath = "#{outdir}/#{page.outpath('.json')}"
      puts "   writing .json to >#{outpath}<"
      write_text( outpath, txtjson )
    end
end  # method self.build_pages


end  # module Pages