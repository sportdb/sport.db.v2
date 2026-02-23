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


end  #  class Lexer
end  # module SportDb
