

##
# build a site (page) index
#




## note - uses Pathname#relative_path_from( basedir )
##   Returns a relative path from the given base_directory to the receiver.
##   If self is absolute, then base_directory must be absolute too.
##   If self is relative, then base_directory must be relative too.
##   This method doesn't access the filesystem. It assumes no symlinks.
##   ArgumentError is raised when it cannot find a relative path.

##
##  todo/check - check if strict - basedir MUST be included in target path
##                            will not use ../ or such to navigate ??
##   e.g. "/home/me/other/foo.txt")  relative_to
##        "/home/me/project"
##     =>  "../other/foo.py"


##
##  move into cocos to - why? why not?
##    use/add  File.relative_path( target,  basedir: ) ???
##
##  note - in python the method is called relpath - see  os.path.relpath( target, basedir )


def relative_path( target, basedir )
    relative = Pathname.new( target ).relative_path_from( Pathname.new( basedir ))
    ## note - returns Pathname object e.g.
    ##             #=> #<Pathname:lib/foo.rb>
    relative.to_s
end




class SiteIndex


def self.build( files, dir:, baseurl: )
   idx = self.new( dir:     dir,
                   baseurl: baseurl )
   idx.add( files )
   idx
end



## use basedir - why? why not?
attr_reader :dir, :baseurl


def initialize( dir:, baseurl: )

     ##
     ##  note - expand dir
     ##    on windows add drive letter e.g.
     ##     /site   =>   c:/sites
     ##    required to make relative_path work

    @dir     = File.expand_path(dir)
    @baseurl = baseurl

    @pages  = []
end



class Page
    ## maybe later -  read meta (title) on demand only
    attr_reader :site, :relpath, :basename


    ### flattened (relative) outpath - incl.
    ###   e.g. 2024-25/1-premier  =>  2024-25_1-premier
    ###
    ###  check/rename   use calc/mk_outpath or such?
    def outpath( extension = '.html')
                         outpath = ""
                         outpath += @relpath

                         ## strip archive/YYYYs/
                         outpath = outpath.sub( %r{^archive/\d{4}s/
                                                   }ix, '' )

                         ## replace  / (slash) with _ (underscore)
                         outpath = outpath.gsub( '/', '_' )

                         outpath += "_"     unless outpath == ''
                         outpath += @basename
                         outpath += extension

                          outpath
    end


    def initialize( site:, relpath:, basename: )
        @site = site    # link to (parent) site

        @relpath  = relpath
        @basename = basename

        ## get meta data block via html-style comment header (in .txt)
        ##    incl.   title, autor(s), source,  updated
        ##  e.g.
        ##    <!--
        ##       title:   Austria 2024/25
        ##       source:  https://rsssf.org/tableso/oost2025.html
        ##       author:  Hans Schöggl
        ##       updated: 7 Jul 2025
        ##      -->
        ##  -or-
        ##      authors: Hans Schöggl and Karel Stokkermans

        ## @meta   =   parse_meta( _read_text() )
    end



    def _read_text
        txt = read_text( "#{@site.dir}/#{relpath}/#{basename}.txt" )

        ## check windows files on unix  -- remove \r - carriage return (cr)
        ##  clean-up windows-style newlines - why? why not?
        txt = txt.gsub( "\r\n", "\n" )
        txt
    end

    ## note - maybe memorize (cache) txt later - why? why not?
    ##    do NOT reread - and freeze text (to make read-only)??
    alias_method :txt,  :_read_text
    alias_method :text, :_read_text


end # (nested) class Page




def add( files )

   files.each_with_index do |file,i|

      dirname  = File.dirname( file )
      relpath = relative_path( dirname, @dir )  ## expects - target, basedir

      extname = File.extname( file )
      basename = File.basename( file, extname )

      print "."
      puts "  relpath: #{relpath}, basename: #{basename}"

      @pages <<  Page.new( site: self,
                              relpath:   relpath,
                              basename:  basename )

   end
   print "\n"
end


def each_page( &block )
    ##  note - sort by basename/slug (as key) - why? why not?
    @pages.each do |page|
        block.call( page )
    end
end

def each_page_with_index( &block )

    ##  note - sort by basename/slug (as key) - why? why not?
    @pages.each_with_index do |page,i|
        block.call( page, i )
    end
end


def pages()  @pages; end
def size()   @pages.size; end

### def has_page?( basename )   @pages.has_key?( basename ); end


end  # class SiteIndex