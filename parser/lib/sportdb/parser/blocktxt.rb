###
#  generic block text/txt helper

## todo/chekc - find a better name SectTxt or ??

class BlockTxt

def self.parse( txt ) new( txt); end 
def self.read( path ) parse( read_text( path )); end


def initialize( txt )
   @sects = _parse( txt )
   self
end

def size()       @sects.size; end

def each( &blk )            @sects.each( &blk ); end
def each_with_index( &blk ) @sects.each_with_index( &blk ); end


def text
    ## only get all txt1 parts joined as single all-in-one string txt
    @sects.map {|sect| sect[0] }.join( "\n" )
end


def dump   ## for debugging
    puts "==> sects (#{@sects.size}):"
    pp @sects
    puts "    #{@sects.size} sect(s)"
end


##
#  quick support for  __END__
END_RE = %r{ ^
                          [ ]* __END__ [ ]*
                            .*?
                         \z   ## note - until end-of-string/file !!!
                      }mx


##    SECT_RE (old) = %r{^
##                                 [ ]* --- [ ]*
##                              $}x
##
##  do NOT use --- (used in fbtxt and markdown and yaml etc.)


## e.g.  §  or §§ or § § § or such
##    maybe allow  :: § :: or such too   or --- § --- or such
SECT_RE = %r{^
                     [ ]* § 
                         ([ ]*§)* 
                     [ ]*
                 $}x

## split by " => or  =====> "
## todo/check - subsect?? find a better name?  in/out or txt1/txt2 
SUBSECT_RE = %r{^
                        [ ]* 
                            =+ > 
                        [ ]*
                  $}x



def _parse( txt )
    blocks = []   ## note - holds [txt,exp] pairs

    txt = txt.sub( END_RE, '' )

    ## split by §
    sections = txt.split( SECT_RE  )

    sections.each_with_index do |sect,i|
       ## puts ">>> start #{i+1}"
       ## pp sect
       ## puts "<<< end #{i+1}"

      txt1, txt2 = sect.split( SUBSECT_RE )
      blocks << [txt1,txt2]
    end

    blocks
end



end # class BlockTxt


###
#  function-style helpers

def read_blocktxt( path ); BlockTxt.read( path ); end
def parse_blocktxt( txt ); BlockTxt.new( txt ); end
