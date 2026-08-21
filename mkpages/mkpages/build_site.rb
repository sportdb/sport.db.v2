

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


def self.build( files, dir:, repo:, branch: 'master' )
   idx = self.new( dir:     dir,
                   repo:    repo,
                   branch:  branch )
   idx.add( files )
   idx
end



## use basedir - why? why not?
attr_reader :dir,
            :repo, :branch    ### for github e.g.   openfootball/england, master (or main)


def initialize( dir:, repo:, branch: )

     ##
     ##  note - expand dir
     ##    on windows add drive letter e.g.
     ##     /site   =>   c:/sites
     ##    required to make relative_path work

    @dir     = File.expand_path(dir)

    @repo    = repo
    @branch  = branch

    @pages  = []
end



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