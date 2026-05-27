
##
## todo/fix - add more round / matchday options!!!


## note use q (downcase) for no-escapes in string (e.g. \d vs \\d etc)

## note - last entry MUST NOT HAVE a pipe (|)
##       make sure to use [ ] for space!!

GROUPS_RE = %r{(?:
                   Group [ ] [A-Z1-9]
               )}ix


ROUNDS_RE = %r{(?:
                   Matchday [ ] \d{1,2}
                |  Round    [ ] \d{1,2}

                |  Group [ ] [A-Z1-9] [ ] play-?off
                |  First [ ] phase
                |  Second [ ] round

                |  Round [ ] of [ ] (?: 8 | 16 | 32 )
                |  1/8 [ ] finals
                |  Quarter-?finals?
                |  Semi-?finals?
                |  Third [ -] place [ ] (?: match | play-?off )
                |  Match [ ] for [ ] third [ ] place
                |  Finals?
         )}ix





FIX_ROUND_MARKER_RE = %r{
                          ^
                        [ ]*   ## ignore leading spaces
                          »    ##   old round marker

                        ## note - use positive lookahead
                        (?= [ ]+)   ##    require one trailing space for now!
                    }ix
FIX_ROUND_MARKER_REPLACE = '▪'



FIX_ROUND_HEADER_RE = %r{
                ^
             [ ]*   ## ignore leading spaces
             (#{ROUNDS_RE} | #{GROUPS_RE})

             ## check POSITIVE lookahead
            (?=
               [ ]*  ## ignore trailing spaces
                (?:
                    \#+ [^\r\n]+?    ## ignore optional inline-comment
                 )?
               $
            )
   }ix

FIX_ROUND_HEADER_REPLACE = '▪ \1'


##
##  e.g.
##    Matchday 1 | ...
##    etc.
##   note - do NOT include GROUPS e.g. Group A, Group 1, etc.
FIX_ROUND_DEF_RE  = %r{
              ^
            [ ]* ## ignore leading spaces
             (#{ROUNDS_RE})

            ## check POSITIVE lookahead
          (?=
              [ ]*  ## ignore trailing spaces
                \|
          )
   }ix

FIX_ROUND_DEF_REPLACE = '▪ \1'



def fix_rounds( txt )
   ## convert "old" legacy round markers (»)
   txt = txt.gsub( FIX_ROUND_MARKER_RE, FIX_ROUND_MARKER_REPLACE )

   ## add round marker to "old" round headers
   txt = txt.gsub( FIX_ROUND_HEADER_RE, FIX_ROUND_HEADER_REPLACE )

   txt = txt.gsub( FIX_ROUND_DEF_RE, FIX_ROUND_DEF_REPLACE )

   txt
end