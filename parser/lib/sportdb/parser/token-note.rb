module SportDb
class Lexer


### fix - use (?<text>) - text capture for inner text!!
##         use (?<note> for complete match as a convention!! )  
NOTE_RE = %r{
    \[ 
      (?<note>
         [^\[\]\#]*?    ## note - non-greedy/lazy operator
                        ##    exclude comments inside note block - why? why not?
      )
    \]
    }xi   


####
##  fix - change NOTE_RE to MATCH_NOTE_RE !!!!
##         and change NOTA_BENE_RE to NOTE_RE !!!



## check for "literal"  (multi-line) note blocks
##   eg.  nb:  or note:          
##   space required after double colon - why? why not?              
##
##  note - use \A (instead of ^) - \A strictly matches the start of the string.
NOTA_BENE_RE =  %r{   \A
                           [ ]*  ## ignore leading spaces (if any)
                        (?: nb | note) [ ]* : [ ]+   
                         (?<nota_bene>
                              .+?  ## use non-greedy 
                          )
                           [ ]*  ## ignore trailing spaces (if any) 
                          \z
                       }xi


end  #  class Lexer
end  # module SportDb
