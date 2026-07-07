module Fbtxt
class Lexer

##  (match) status inline versions




## "inline" match status e.g.
##  Clapham Rovers     w/o  Hitchin
##  Queen's Park       bye

## add support for WO or W-0 too - why? why not?
INLINE_WO_RE = %r{
                   (?<inline_wo>
                       \b (?: w/o | W/O ) \b
               )}x   ## note - NOT case insensitive

INLINE_BYE_RE = %r{
                  (?<inline_bye>
                      \b (?: bye | BYE ) \b
               )}x   ## note - NOT case insensitive


###
#   A n/p  B    (note - basically a inline short form of  A v B [cancelled] )
#     N/P
INLINE_NP_RE = %r{
                   (?<inline_np>
                       \b (?: n/p | N/P ) \b
               )}x   ## note - NOT case insensitive


###
#  abd/abd. or aban/aban.  [abandoned]
#  ABD/ABAN
INLINE_ABD_RE = %r{
                   (?<inline_abd>
                       \b (?: abd\.? |
                              aban\.? |
                              ABD | ABAN
                          )
                  ## POSITIVE lookahead - requires space
                         (?= [ ])
               )}x  ## note - NOT case insensitive

####
#  susp/susp.  [suspended]
#   SUSP
INLINE_SUSP_RE = %r{
                   (?<inline_susp>
                       \b (?: susp\.? |
                               SUSP )
                  ## POSITIVE lookahead - requires space
                         (?= [ ])
               )}x  ## note - NOT case insensitive


####
# ppd/ppd. or pst/pst. or pstp/pstp. or postp/postp.   [postponed]
#  PPD/PSTP/POSTP/P-P
#   todo/check - add/allow p-p too - why? why not?
INLINE_PPD_RE = %r{
                   (?<inline_ppd>
                       \b (?: ppd\.? |
                              pst\.? |
                              po?stp\.? |
                              PPD | PST | PO?STP | P-P
                           )
                  ## POSITIVE lookahead - requires space
                         (?= [ ])
               )}x   ## note - NOT case insensitive

####
#  void via   x-x X-X
#     todo/check - only allow X-X - why? why not?
INLINE_VOID_RE = %r{
                      (?<inline_void>
                          \b (?: x-x |
                                 X-X
                             )
                        ## POSITIVE lookahead - requires space
                           (?= [ ])
                )}x ## note - NOT case insensitive


####
#  awd/awd.                [awarded]
#   AWD
#   note - recommendation is to allways include score
#            thus, use/prefer SCORE_AWD e.g. 0-3 awd
INLINE_AWD_RE =  %r{
                   (?<inline_awd>
                       \b (?: awd\.? | AWD )
                  ## POSITIVE lookahead - requires space
                         (?= [ ])
               )}x   ## note - NOT case insensitive

###
#  canc/canc.           [cancelled]
#    CANC
INLINE_CANC_RE =  %r{
                   (?<inline_canc>
                       \b (?: canc\.?  | CANC )
                  ## POSITIVE lookahead - requires space
                         (?= [ ])
               )}x   ## note - NOT case insensitive



end  # class Lexer
end  # module Fbtxt
