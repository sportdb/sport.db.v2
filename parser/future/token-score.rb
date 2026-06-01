
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
