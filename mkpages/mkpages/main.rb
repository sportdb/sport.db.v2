

## rename to   MkPages for module - why? why not?
module Pages


def self.main( args=ARGV )
##
##  add -j/--[no-]json generation option - why? why not?

 opts = {
   outdir:     './_site',
   rootdir:    '.',
   index:      true,

   repo:      ENV['GITHUB_REPOSITORY'],
   branch:    'master',   ## note - hard-code for now; use env too in future
   ## baseurl:    nil,
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

     parser.on( "--repo REPO",
                 "(github) repo e.g. {owner}/{name} for view/edit link, .txt and more (default: #{opts[:repo]})" ) do |repo|
       opts[:repo] = repo
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
repo    = opts[:repo]
branch  = opts[:branch]



### note - auto-excludes .edits.txt
##           e.g. braz2024.edits.txt.
files =   Fbtxt::Pathspec.find( rootdir )

###
#
#  note - add upstream more excludes
#    required for nested github checkouts e.g.
# relpath: sport.db.v2/prompts/worldcup_final, basename: googleai-final_v3
#  relpath: sport.db.v2/prompts/worldcup_final, basename: googleai_final_v4
# relpath: sport.db.v2/sandbox, basename: quick
# relpath: vendor/bundle/ruby/3.2.0/gems/cocos-0.4.2, basename: Manifest
# relpath: vendor/bundle/ruby/3.2.0/gems/csvjson-1.0.1, basename: Manifest


## note - work path in github is:
##   e.g. /home/runner/work/england/england

files = files.select do |file|
                          ## exclude our own script
                          ##   housed in /sport.db.v2 !!!
                         if file.include?( '/sport.db.v2/' )
                             false
                         elsif file.include?( '/.git/' ) ||
                               file.include?( '/vendor/' ) ||
                               file.include?( '/bundle/' )
                            false
                         else
                            true
                         end
                     end


puts "    #{files.size} source .txt file(s) found"


site = SiteIndex.build( files, dir:     rootdir,
                               repo:    repo,
                               branch:  branch )


build_pages( site, outdir: outdir )
build_index( site, outdir: outdir )

## write out sitewide stylesheet (style.css)
build_style( outdir: outdir )


end  # method self.main




def self.build_pages( site, outdir: )


  ## todo/check - why each_page.with_index is not working??)
    site.each_page_with_index do |page,i|

      outpath = "#{outdir}/#{page.outpath('.html')}"
      puts "==> [#{i+1}/#{site.size}] building page #{outpath} (#{page.relpath}/#{page.basename}.txt)..."


      doc = Fbtxt::Document.parse( page.text )

      if doc.errors?
        puts "!! ERROR  -  #{doc.errors.size} parse error(s):"
        pp doc.errors
        ## exit 1

        page.errors = doc.errors

        data = { 'name'    => doc.title,
                 'errors'  => doc.errors.as_json,
                 'matches' => doc.matches.as_json,  ## keep matches - why? why not?
                  }

      else
        page.errors = []

        data = { 'name'    => doc.title,
                 'matches' => doc.matches.as_json }
      end


      ####
      #  note: parse page first (before build)
      #          fills-up Page::Stat#errors

      html = build_page( page )

      write_text( outpath, html )



      ###
      ## generate json

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