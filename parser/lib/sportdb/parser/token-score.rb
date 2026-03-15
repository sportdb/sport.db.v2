module SportDb
class Lexer


   

    ## todo/check: use ‹› (unicode chars) to mark optional parts in regex constant name - why? why not?

    #####
    #  english helpers (penalty, extra time, ...)
    ##   note - p must go last (shortest match)
    #     pso = penalty shootout
    ###  - note - remove PSO for now (may add later back) - why? why not? 
    #
    #  todo/fix/clean-up - keep it simple -  remove optional trailing dot (.)
    #                       from pen., p., agg. etc. - why? why not?
    #                        always use (simply) pen, p, agg 
    #                      (also) remove  a.e.t. / a.e.t option - why? why not?
    #
    ##  UPDATE mar/2026:  addd pens too - keep - why? why not?
    ##                     (4-3 pens)
    ##  (4-3 Pens)  -- keep mixed Pens/Pen. too - why? why not?
    ##  (4-3 Pen.)
    P_EN  =  '(?-i: PEN | P |' +
                   '[Pp]ens | [Pp]en\.? | p\.? )'     # e.g. p., p, pen, pen., etc.


    ## fix - change ET_EN  to AET_EN!!! - why? why not?
    ##   check - allow Aet too - why? why not?
    ##              or A.e.t ??
    ET_EN =  '(?-i: AET | ' +
                   'aet | a\.e\.t\.? )'     # note: make last . optional (e.g a.e.t) allowed too
    # AET_EN = ET_EN

    ####
    ## after (golden goal/sudden death) extra time   - add more options/styles - why? why not?
    AETGG_EN  = '(?-i: AET/GG | AGGET | ASDET | ' +
                      'aet/gg | a\.e\.t\.?/g\.g\.? | agget | asdet )'
    ## after (silver goal) extra time
    AETSG_EN  = '(?-i: AET/SG | ASGET | ' +
                      'aet/sg | a\.e\.t\.?/s\.g\.? | asget  )'
    
    ##  agg/agg.  or AGG
    AGG_EN = '(?-i: AGG | agg\.? )'   ## aggregate e..g  4-4 agg etc.
  

    
    ## regex score helpers
    ##    note - MUST double escape \d e.g. \\d!!!   if not "simple" string (e.g. '' but %Q<>)

    ##
    ##  fix - change SCORE_P to SCORE_FULL_P
    ##               SCORE_ET to SCORE_FULL_ET
    ##
    ##   (re)use SCORE_P, SCORE_ET for score only part!!!

    SCORE_P   = %Q<  (?<p1>\\d{1,2}) - (?<p2>\\d{1,2})
                          [ ]? #{P_EN}
                  >
    SCORE_ET  = %Q<  (?<et1>\\d{1,2}) - (?<et2>\\d{1,2})
                          [ ]? #{ET_EN}
                  >
    SCORE_LOOKAHEAD = '(?= [ ,\]] | $)'

    
    ####
    ## after extra-time with golden goal/sudden death & silver goal rule
    ##        note - golden goal & silver goal EXCLUDE penalties!!!
    ##
    ##  4-3 a.e.t/g.g.
    ##  4-3 aet/gg
    ##  4-3agget   -or-   4-3 asdet
    ##  2-1 aet/sg
    ##   -or-
    ##   4-3 aet/gg (3-3, 2-1)
    SCORE__ET_GG_SG__RE = %r{
        (?<score_full>
           \b
           (?<et1>\d{1,2}) - (?<et2>\d{1,2})
                          [ ]? (?:
                                   (?<aetgg> #{AETGG_EN})
                                      |
                                   (?<aetsg> #{AETSG_EN})
                                )
           ### note:
           ## add optional full-time, half-time score
             (?:
                 [ ]+
                 \(
                    [ ]*
                   (?<ft1>\d{1,2}) - (?<ft2>\d{1,2})
                      [ ]*
                    (?:
                       , [ ]*
                       (?: (?<ht1>\d{1,2}) - (?<ht2>\d{1,2})
                         [ ]*
                      )?
                   )? # note: make half time (HT) score optional for now
                 \)
             )?                     
            #{SCORE_LOOKAHEAD}
    )}ix


    ##  note: allow SPECIAL cases WITHOUT full time scores (just a.e.t or pen. + a.e.t.)
    ##      3-4 pen. 2-2 a.e.t.
    ##      3-4 pen.   2-2 a.e.t.
    ##               2-2 a.e.t.
    SCORE__P_ET__RE = %r{
        (?<score_full>
           \b
            (?: #{SCORE_P} [ ]+ 
             )?             ## note: make penalty (P) score optional for now
            #{SCORE_ET}
            #{SCORE_LOOKAHEAD}
        )}ix
                ## todo/check:  remove loakahead assertion here - why require space?
                ## note: \b works only after non-alphanum e.g. )


    ##  note: allow SPECIAL cases WITHOUT full time scores 
    ##         AND with pen in last position!
    ##           2-2 a.e.t., 3-4 pen. 
    ##           2-2 a.e.t.  3-4 pen.  ## or without comma separator - why? why not?   
    SCORE__ET_P__RE = %r{
        (?<score_full>
           \b
            #{SCORE_ET}  
               (?: [ ]*,[ ]* | [ ]+ )
            #{SCORE_P}  
            #{SCORE_LOOKAHEAD}
        )}ix
                ## todo/check:  remove loakahead assertion here - why require space?
                ## note: \b works only after non-alphanum e.g. )

    ### special case (i)  - full time with penalties
    ##          2-2, 3-4 pen.
    SCORE__FT_P__RE = %r{
        (?<score_full>
           \b
            (?<ft1>\d{1,2}) - (?<ft2>\d{1,2})  
                [ ]*,[ ]*    ## note - comma required!!! 
            #{SCORE_P}  
            #{SCORE_LOOKAHEAD}
        )}ix

    ### special case (ii)  - full time & half-time with penalties
    ##          2-2 (1-1), 3-4 pen.
    SCORE__FT_HT_P__RE = %r{
        (?<score_full>
           \b
            (?<ft1>\d{1,2}) - (?<ft2>\d{1,2})
                [ ]*
                 \(
                     (?<ht1>\d{1,2}) - (?<ht2>\d{1,2})
                 \)
                [ ]*,[ ]*    ## note - comma required!!! 
            #{SCORE_P}  
            #{SCORE_LOOKAHEAD}
        )}ix




    ##  note: allow SPECIAL with penalty only
    ##      3-4 pen.  or 3-4p etc.
    SCORE__P__RE = %r{
        (?<score_full>
           \b
             #{SCORE_P}  
             #{SCORE_LOOKAHEAD}
         )}ix
                ## todo/check:  remove loakahead assertion here - why require space?
                ## note: \b works only after non-alphanum e.g. )

   ####
   ## support short all-in-one e.g.
   ##  e.g.      3-4 pen. 2-2 a.e.t. ( 1-1, 1-1 ) becomes
   ##   3-4 pen. (2-2, 1-1, 1-1)            
         
   SCORE__P_ET_FT_HT_V2__RE = %r{
          (?<score_full>
               \b
                #{SCORE_P} [ ]+       
                   \(
                   [ ]*
               (?<et1>\d{1,2}) - (?<et2>\d{1,2})
                   [ ]*, [ ]*
               (?<ft1>\d{1,2}) - (?<ft2>\d{1,2})
                   [ ]*, [ ]*
               (?<ht1>\d{1,2}) - (?<ht2>\d{1,2})
                   [ ]*
                \)
               #{SCORE_LOOKAHEAD}
            )}ix       ## todo/check:  remove loakahead assertion here - why require space?
                               ## note: \b works only after non-alphanum e.g. )


    # e.g. 2-2 a.e.t. (1-1, 1-0), 5-1 pen. 
    SCORE__ET_FT_HT_P__RE = %r{
          (?<score_full>
               \b
               #{SCORE_ET} [ ]+
                   \(
                   [ ]*
              (?<ft1>\d{1,2}) - (?<ft2>\d{1,2})
                   [ ]*
                (?:
                     , [ ]*
                    (?: (?<ht1>\d{1,2}) - (?<ht2>\d{1,2})
                        [ ]*
                    )?
                )?              # note: make half time (HT) score optional for now
              \)
               (?: [ ]*,[ ]* | [ ]+)
               #{SCORE_P}
               #{SCORE_LOOKAHEAD}
            )}ix       ## todo/check:  remove loakahead assertion here - why require space?
                               ## note: \b works only after non-alphanum e.g. )

    

    ## e.g. 3-4 pen. 2-2 a.e.t. (1-1, 1-1)  or
    ##      3-4p 2-2aet (1-1, )     or
    ##      3-4 pen.  2-2 a.e.t. (1-1)       or
    ##               2-2 a.e.t. (1-1, 1-1)  or
    ##               2-2 a.e.t. (1-1, )     or
    ##               2-2 a.e.t. (1-1)

    SCORE__P_ET_FT_HT__RE = %r{
          (?<score_full>
               \b
               (?:
                  #{SCORE_P} [ ]+
                )?            ## note - make penalty (P) score optional for now
               #{SCORE_ET} [ ]+
                   \(
                   [ ]*
              (?<ft1>\d{1,2}) - (?<ft2>\d{1,2})
                   [ ]*
                (?:
                     , [ ]*
                    (?: (?<ht1>\d{1,2}) - (?<ht2>\d{1,2})
                        [ ]*
                    )?
                )?              # note: make half time (HT) score optional for now
              \)
             #{SCORE_LOOKAHEAD}
            )}ix       ## todo/check:  remove loakahead assertion here - why require space?
                               ## note: \b works only after non-alphanum e.g. )

    ###
    ##   special case for case WITHOUT extra time!!
    ##     same as above (but WITHOUT extra time and pen required)
    SCORE__P_FT_HT__RE = %r{
             (?<score_full>
                \b
               #{SCORE_P} [ ]+
        \(
        [ ]*
      (?<ft1>\d{1,2}) - (?<ft2>\d{1,2})
        [ ]*
     (?:
          , [ ]*
         (?: (?<ht1>\d{1,2}) - (?<ht2>\d{1,2})
             [ ]*
         )?
     )?              # note: make half time (HT) score optional for now
   \)
    #{SCORE_LOOKAHEAD}
    )}ix    ## todo/check:  remove loakahead assertion here - why require space?
            ## note: \b works only after non-alphanum e.g. )


    ##########
    ## e.g. 2-1 (1-1)
    SCORE__FT_HT__RE = %r{
            (?<score_full>
              \b
              (?<ft1>\d{1,2}) - (?<ft2>\d{1,2})
                   [ ]+ \( [ ]*
                (?<ht1>\d{1,2}) - (?<ht2>\d{1,2})
                   [ ]* \)
             #{SCORE_LOOKAHEAD}
             )}ix    ## todo/check:  remove loakahead assertion here - why require space?
                    ## note: \b works only after non-alphanum e.g. )



             
#############################################
# map tables
#  note: order matters; first come-first matched/served

SCORE_FULL_RE = Regexp.union(
  SCORE__ET_GG_SG__RE,       # e.g. 3-1 aet/gg  
  SCORE__P_ET_FT_HT_V2__RE,  # e.g. 5-1 pen. (2-2, 1-1, 1-0)  
  SCORE__ET_FT_HT_P__RE,    # e.g. 2-2 a.e.t. (1-1, 1-0), 5-1 pen. 
  SCORE__P_ET_FT_HT__RE,    # e.g. 5-1 pen. 2-2 a.e.t. (1-1, 1-0)
  SCORE__P_FT_HT__RE,     # e.g. 5-1 pen. (1-1)
  SCORE__ET_P__RE,        # e.g. 2-2 a.e.t., 5-1 pen.
  SCORE__FT_P__RE,        # e.g. 2-2, 5-1 pen.
  SCORE__FT_HT_P__RE,     # e.g. 2-2 (1-1), 5-1 pen.
  SCORE__P_ET__RE,        # e.g.  5-1 pen. 2-2 a.e.t.  or  2-2 a.e.t. (w/o pen)
  SCORE__P__RE,           # e.g. 5-1 pen.
  SCORE__FT_HT__RE,        # e.g. 1-1 (1-0)
  ##  note - keep basic score as its own token!!!!
  ##   that is, SCORE & SCORE_MORE
  ### SCORE__FT__RE,           # e.g. 1-1  -- note - must go last!!!
)


###
##
##  add support for score awarded (inline style)
##    3-0 awd  3-0 awd. 3-0awd 
##    0-1 awd  or 0-1 AWD etc.

##
##   note - keep AWD w/o dot - why? why not?

SCORE_AWD_RE  = %r{
            (?<score_awd>
              \b
               (?<score1>\d{1,2}) - (?<score2>\d{1,2})
                 [ ]?
                   (?-i: awd\.? | AWD )
               ## POSITIVE lookahead - requires space
               (?= [ ])
             )}ix  

###
##
##  add support for score abandoned (inline style)
##       2-1 abd.   or 2-1 ABD
SCORE_ABD_RE  = %r{
            (?<score_abd>
              \b
               (?<score1>\d{1,2}) - (?<score2>\d{1,2})
                 [ ]?
                  (?-i: abd\.? | ABD )
               ## POSITIVE lookahead - requires space
               (?= [ ])
             )}ix  

#####
##      2-1
###
###  note - was SCORE__FT__RE
###           changed to "generic" SCORE_RE
###                and
##             (?<ft1>\d{1,2}) - (?<ft2>\d{1,2}) 
##      changed
##             (?<score1>\d{1,2}) - (?<score2>\d{1,2}) 
##                to 
##             pattern match not necessarily the full-time (ft) scoreline!!!
##    - pattern also used for goal seq(uence) e.g. 1-0 Kane, 1-1 Johnson
SCORE_RE  = %r{
            (?<score>
              \b
               (?<score1>\d{1,2}) - (?<score2>\d{1,2})
              \b
             )}ix  


######
#  add support for "split" score
#    note - for now (2) 1  is REQUIRED

SCORE_TEAM_RE = %r{
            (?<score_team>
                 \(
                    (?<score_i> \d{1,2}) 
                 \)
                 [ ]*   ## note - space optional- why? why not?
                    (?<score_ii> \d{1,2})
                \b 
            )
        }ix   

#     "penalty"-style  (4) is assumed penalty score
#    note - for now 1 (4) is REQUIRED

SCORE_TEAM_PEN_RE = %r{
            (?<score_team_pen>
                 \b
                    (?<score_i> \d{1,2})
                 \b
                   [ ]*  ## note - space optional- why? why not?  
                 \(
                    (?<score_pen> \d{1,2}) 
                 \)
            )
        }ix   

########
## note - score_team_num (<100) e.g. 0, 1, .., 10, 11, .. 99
##      use a different name - why? why not? 
##   note - must be surrouned by space
SCORE_TEAM_NUM_RE = %r{
    ## positive lookbehind
     (?<= [ ])

      (?<score_team_num> \d{1,2} )

     ## positive lookahead
     (?= [ ]|\z)
}x



def self._build_score_team( m )
            score = {}
            ##  note - score team is "generic"
            ##      might be full-time (ft) or
            ##         after extra-time (aet) or such
            ##         or even undecided/unknown
            ##    thus, use score_i/score_ii 
            score[:score] = [m[:score_i].to_i(10),
                             m[:score_ii].to_i(10)]  
            score
end 
def _build_score_team( m ) self.class._build_score_team( m ); end 


def self._build_score_team_pen( m )
            score = {}
            score[:score] = [m[:score_i].to_i(10),
                             m[:score_pen].to_i(10)]  
            score
end 
def _build_score_team_pen( m ) self.class._build_score_team_pen( m ); end 


def self._build_score_team_num( m )
            score = {}
            score[:score] = m[:score_team_num].to_i(10)
            score
end 
def _build_score_team_num( m ) self.class._build_score_team_num( m ); end 


end  #  class Lexer
end  # module SportDb
