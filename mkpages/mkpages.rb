############
#  to run use:
#   $ ruby mkpages/mkpages.rb

##
###  generate web site
##      - web pages in .html from .txt



require 'cocos'

require 'pathname'
## auto-add upstream in cocos - why? why not?
##      (for use of  Pathname#relative_path_to)



require 'fbtok'   ### pulls-in  Fbtxt::Pathspec.find()


require 'fbtxt/document'



require_relative 'mkpages/build_page'
require_relative 'mkpages/build_site'


=begin
require_relative 'mkpages/build_index'
require_relative 'mkpages/build_codes'
require_relative 'mkpages/build_updates'
require_relative 'mkpages/build_links'
require_relative 'mkpages/meta'      ## parse_meta  --in html-style comment header


require_relative 'mkpages/page_toc'     ## table of contents (toc)
=end

require_relative 'mkpages/page_banner'
require_relative 'mkpages/page_layout'   ## aka master page layout/template




##
##  add -j/--json generation option - why? why not?


 args = ARGV

 opts = {
   outdir:     './_site',
   rootdir:    '/sports/openfootball/england',
   index:      false,
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


### note - auto-excludes .edits.txt
##           e.g. braz2024.edits.txt.
files =   Fbtxt::Pathspec.find( rootdir )
puts "    #{files.size} source .txt file(s) found"



site = SiteIndex.build( files, dir: rootdir )


def build_pages( site, outdir: )
    ## todo/check - why each_page.with_index is not working??)
    site.each_page_with_index do |page,i|

      outpath = "#{outdir}/#{page.outpath}"
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
end



build_pages( site, outdir: outdir )



def build_style( outdir: )

  css =<<CSS

a, a:visited {
  text-decoration: none;
}

a:hover {
  text-decoration: underline;
}


/*********
  reset h1,h2,h3,h4,h5,h6 formatting inside pre blocks
  ****/

  pre h1,
  pre h2,
  pre h3,
  pre h4,
  pre h5,
  pre h6 { /* color: red;  */
            font-size: 100%;
            margin: 0;
             }



   pre h1,
   pre h2,
   pre h3 {
      font-size: 150%;
   }

  pre h4 {
     /* add blue-ish background */
     background-color: #CCCCFF;
     padding-top: 1px;
     padding-bottom: 1px;
  }


  pre h5 {
            /* bold by default keep */
         }

 pre h6 {
            font-weight: normal;
            /* use underline */
            text-decoration: underline;
         }

   pre span.comment {
            color: green;
      }

CSS

   write_text( "#{outdir}/style.css", css )
end



## write out sitewide stylesheet (style.css)
build_style( outdir: outdir )


puts "bye"
