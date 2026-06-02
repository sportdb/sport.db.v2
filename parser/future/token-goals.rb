


## minute variant for  N/A not/available
##     todo/check - find a better syntax - why? why not?
##
##   note  "??".to_i(10) returns 0 or
##         "__".to_i(10) returns 0
##   quick hack - assume 0 for n/a for now

=begin
MINUTE_NA_RE = %r{
   (?<minute>
      (?<=[ (])	 # positive lookbehind for space or opening
        (?<value> \?{2} | _{2} )
        '   ## must have minute marker!!!!
    )
}ix
=end

## note - leave out n/a minute in goals - make minutes optional!!!
PROP_GOAL_RE =  Regexp.union(
    GOAL_BASICS_RE,
    MINUTE_RE,
   ## MINUTE_NA_RE,   ## note - add/allow not/available (n/a,na) minutes hack for now
    GOAL_OG_RE, GOAL_PEN_RE,
    SCORE_RE,
    PROP_NAME_RE,    ## note - (re)use prop name for now for (player) name
)
