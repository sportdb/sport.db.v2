
## "top-level" regex used for:


HRULER_RE = %r{
                 \A
                           [ ]*  ## ignore leading spaces (if any)
                    -{3,}  ## must be at least three dashes!!!
                           [ ]*  ## ignore trailing spaces (if any)
                 \z
}ix




RE = Regexp.union(

                    ## note - add "experimental" "split" scores for now
                    SCORE_TEAM_RE,   ##  e.g. (2) 1  for "split" scores
                    SCORE_TEAM_PEN_RE,   ##  e.g. 1 (2)

                    ## note - score_team_num (e.g. 0 or 10 etc.)
                     ##            MUST BE after TEXT
                     ##              only match if nothing else matches (expect ANY)
                    SCORE_TEAM_NUM_RE,   ## e.g. 0 or 1 or 9 or 11 etc. (<100)

)