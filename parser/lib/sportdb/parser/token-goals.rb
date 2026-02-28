module SportDb
class Lexer


######################################################
## goal mode (switched to by PLAYER_WITH_MINUTE_RE)  
##
##  note - must be enclosed in ()!!! 
##          todo - add () in basics - why? why not?



##
##  todo/fix - split up BASICS!!!
##      break out SPACES_RE  for general reuse!!!
##       makes it easier to  use "custom" symbols (<sym>) 


GOAL_BASICS_RE = %r{
    (?<spaces> [ ]{2,}) |
    (?<space>  [ ])
        |
    (?<sym>  
        [;,)]   ##  add (-) dash too - why? why not?   
    )   
}ix


## note - assume lines starting with opening ( are goal lines!!!!
##  note - use \A (instead of ^) - \A strictly matches the start of the string.
##
##   note -  check for negative lookahead
##                 to exclude ord (numbers) e.g.  (1), (42), etc.!!!
GOAL_LINE_RE = %r{
                     \A\(
                       # check NEGATIVE lookahead
                       (?! 
                             ##  exclude ord
                             (?: \d+ \))  
                                 |
                            ## exclude score - goal_line_alt!!!
                             (?: [ ]* \b
                                        \d-\d   ## score e.g. 1-0
                                      \b  )   
                       )	 	
                 }xi


###
##  check for goal line (alternate syntax)
##    (1-0 Player, 1-1 Player, ...)       
#    must start off with score          
GOAL_LINE_ALT_RE = %r{
                     \A\(
                       # check POSITIVE lookahead
                       (?= [ ]* \b 
                                 \d-\d    ## score e.g. 0-1 
                                  \b )	 	
                 }xi


###
##  e.g.  (-; Metzger)
GOAL_NONE_RE = %r{ (?<goals_none>
                        -[ ]*;
                    )
                 }x

###
#  note - alternate goal separator dash (-) MUST have leading and trailing space!!!
#    e.g.   (Metzger 83 - Krämer 29, 88, Cichy 33, Rahn 37)
#    e.g.   (Metzger - Krämer (2), Cichy, Rahn)
#            (Brunnenmeier 17 - Gerwien 74)
#            (Brunnenmeier - Gerwien)
#    that is,  NOT allowed  
#    e.g.   (Metzger 83-Krämer 29, 88, Cichy 33, Rahn 37)
#            (Brunnenmeier 17-Gerwien 74)
#            (Brunnenmeier-Gerwien) 
#
#   note - allow split by - e.g.
#     Frankfurt   4-2 Schalke     (Kreß 45, Solz 55, Trimhold 58, Huberts 73 p -
#                                  Berz 7, Herrmann 74)


GOAL_SEP_ALT_RE = %r{
          (?<goal_sep_alt>
              (?<=[ ])   ## positive lookbehind - space required
              -
              (?=[ ]|\z)    ## positive lookahead - speace required
             )}x


## e.g.  (2)
##       (2/p), (2/pen.), (3/2p), (3/ 2 pen.) 
##      -or-  (2,1pen), (3, 2 pens)
## 
##       (p), (pen.) (2 pen.), (2p)               
##       (og), (o.g.), 
##        (2og), (2 o.g.), (2ogs)
#
##

GOAL_COUNT_RE = %r{
   (?<goal_count>
      \(
        (?:
          ## opt penalties
            (?<pen>
              (?:  (?<pen_value> \d{1,2}) [ ]? )?
                 (?:pens|pen\.?|p)
           )
            |
          ## opt own goals (og)
            (?<og>
             (?: (?<og_value> \d{1,2}) [ ]? )?
                (?:ogs?|o\.g\.|o) 
            )          
            |
          ## opt fallback - classic count/number
          (?:  (?<value> [1-9])
                ## check for option penalties
                (?<pen>
                     [,/] [ ]*
                     (?: (?<pen_value> \d{1,2}) [ ]? )?
                     (?:pens|pen\.?|p)
                )?
           )
         )  
      \)
)}ix


##   goal types
# (pen.) or (pen) or (p.) or (p)
## (o.g.) or (og)
##   todo/check - keep case-insensitive 
##                   or allow OG or P or PEN or
##                   only lower case - why? why not?
##
##  add (gg) for golden goal - why? why not?
##  add (sg) for silver goal - why? why not??

GOAL_MINUTE_RE = %r{
     (?<goal_minute>
               \b
             (?<value>\d{1,3})      ## constrain numbers to 0 to 999!!!
                '?    ## optional minute marker
                
             (?: (?<plus>\+)  ## note - allow 46+,94+,97+ etc. too for now - why? why not?
                 (?: (?<value2>\d{1,3})   
                      '?    ## optional minute marker
                 )?
             )?          
                   
        ## note - add goal minute qualifiers here inline!!! 
        (?:
            (?: [ ]? (?<og>   (?: \((?:og|o\.g\.|o)\))   ## allow (og)
                                   |
                              (?: (?:og|o\.g\.|o))      ## allow plain og
                      )
            )
            |
            (?: [ ]? (?<pen>  (?: \((?:pen\.?|p)\))   ## allow ()
                                   |
                              (?: (?:pen\.?|p))
                      )    
            )
            |
            ## add experimental h(eader) qualifier
            (?: [ ]? (?<h> \( h \) | h ))
            |
            ## add experimental f(ree kick) qualifier
            (?: [ ]? (?<f> \( f \) | f ))
        )?

        ##  add experimental seconds
        ##    e.g. (95 secs) or (95sec) etc. 
        (?: [ ]*  \(
                      (?<secs>\d{1,3})
                         [ ]?secs?
                   \) 
        )?
     )

     ## note - check positive lookahead 
     (?=[ ,;)]|$)   
}ix






GOAL_RE = Regexp.union(
    GOAL_BASICS_RE,
    GOAL_NONE_RE,
    GOAL_MINUTE_RE,
    GOAL_COUNT_RE,
   ## MINUTE_NA_RE,   ## note - add/allow not/available (n/a,na) minutes hack for now
   ## GOAL_OG_RE, GOAL_PEN_RE,
   ## SCORE_RE,  ## add back in v2 (level 3) or such!!
    PROP_NAME_RE,    ## note - (re)use prop name for now for (player) name
    GOAL_SEP_ALT_RE,
    ## todo/fix - add ANY_RE !!!!
)



GOAL_TYPE_RE = %r{
     (?<goal_type>
               \(
                 (?:
                      (?<og>  og|o\.g\.|o )  
                         |
                      (?<pen> pen\.?|p )  
                         |
                     ## add experimental h(eader) qualifier
                      (?<h>  h )
                         |
                     ## add experimental f(ree kick) qualifier
                       (?<f>  f )
                  )
                \)
)}xi



GOAL_ALT_RE = Regexp.union(
    GOAL_BASICS_RE,
    SCORE_RE,        ## e.g.  1-0, 0-1, etc.
    GOAL_MINUTE_RE,
    GOAL_TYPE_RE,
    PROP_NAME_RE,    ## note - (re)use prop name for now for (player) name
    ## todo/fix - add ANY_RE !!!!
)


=begin
## note - leave out n/a minute in goals - make minutes optional!!!
PROP_GOAL_RE =  Regexp.union(
    GOAL_BASICS_RE,
    MINUTE_RE,
   ## MINUTE_NA_RE,   ## note - add/allow not/available (n/a,na) minutes hack for now
    GOAL_OG_RE, GOAL_PEN_RE,
    SCORE_RE,
    PROP_NAME_RE,    ## note - (re)use prop name for now for (player) name
)
=end




def self._parse_goal_minute( str )  
    ## note - strip - leading/trailing spaces
    m = GOAL_MINUTE_RE.match( str.strip )
    if m && m.pre_match == '' && m.post_match == ''
      _build_goal_minute( m )
    elsif  m
        ## note - match BUT not anchored to start and end-of-string!!!
        ##  report, error somehow??
      nil   
    else
      nil  ## no match - return nil
    end
end

def self._build_goal_minute( m )
    minute = {}
    value =  m[:value].to_i(10)   ## always required

    if m[:plus] && m[:value2].nil?  ## check for 47+, 93+
        if value < 90        # assume 1st half (45+xx)
          minute[:m]      = 45
          minute[:offset] = value - 45
        elsif value < 105    # assume 2nd half (90+xx)
          minute[:m]      = 90
          minute[:offset] = value - 90
        elsif value < 120    # assume extra time, 1nd half (105+xx)
          minute[:m]      = 105
          minute[:offset] = value - 105
        else                 # assume extra time, 2nd half (120+xx)
          minute[:m]      = 120
          minute[:offset] = value - 120
        end
    else
      minute[:m] = value
    end
    
    minute[:offset] = m[:value2].to_i(10)   if m[:value2]
    
    minute[:og]  = true    if m[:og]
    minute[:pen] = true    if m[:pen]
    minute[:freekick] = true    if m[:f]
    minute[:header] = true    if m[:h]
  
    minute[:secs] = m[:secs].to_i(10)   if m[:secs]
  
    minute
end
def _build_goal_minute( m ) self.class._build_goal_minute( m ); end
    


def self._parse_goal_count( str )  
    ## note - strip - leading/trailing spaces
    m = GOAL_COUNT_RE.match( str.strip )
    if m && m.pre_match == '' && m.post_match == ''
      _build_goal_count( m )
    elsif  m
        ## note - match BUT not anchored to start and end-of-string!!!
        ##  report, error somehow??
      nil   
    else
      nil  ## no match - return nil
    end
end

def self._build_goal_count( m )
    count = {}
    count[:count] = m[:value].to_i(10)        if m[:value]
    count[:og]    = m[:og_value] ? m[:og_value].to_i(10) : 1      if m[:og]   ## check flag
    count[:pen]   = m[:pen_value] ? m[:pen_value].to_i(10) : 1    if m[:pen]  ## check flag
    count
end
def _build_goal_count( m ) self.class._build_goal_count( m ); end




def self._build_goal_type( m )
    goal = {}
    goal[:og]       = true  if m[:og]
    goal[:pen]      = true  if m[:pen]
    goal[:freekick] = true  if m[:f]
    goal[:header]   = true  if m[:h]
    goal
end
def _build_goal_type( m ) self.class._build_goal_type( m ); end




end  # class Lexer
end # module SportDb
