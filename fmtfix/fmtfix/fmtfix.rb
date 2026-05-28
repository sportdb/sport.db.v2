



ORD_RE = %r{  ^
                [ ]*  ## optional leading spaces
                  \( \d{1,2} \)
                [ ]+  ## (single) space required for now
              }ix


##
##      [Gazinsky 12' Cheryshev 43', 90+1' Dzyuba 71' Golovin 90+4']
##        [-; Giménez 89']
##       [Ángel di María 118']
##        [Mario Götze 113']
##        90+5'

GOAL_LINE_RE = %r{ ^
                  ([ ]*)  ## (1) optional leading spaces
                  (\[)   ## (2) open bracket
                  (      ## (3) body
                     [^0-9'\[\]();,]+?
                         ## check for single machting minute for now
                          [ ]
                           \d{1,3}
                           (?: \+\d{1,2})?
                           '

                         ## eat-up (optional) rest
                          [^\[\]]*?

                   )
                  (\])   ## (4) close bracket
                  [ ]*  ## optional trailing spaces
                 $
               }ix
## note - keep leading spaces
GOAL_LINE_REPLACE = '\1(\3)'


GOAL_NONE_RE = %r{  ^
                  (                     ## (1) before goal none
                    [ ]*  ## optional leading spaces
                    \[
                  )
                  ( [ ]* - [ ]* ; [ ]*)   ## (2) goal none

                   ## check POSITIVE lookahead
                    (?=
                        ## eat-up (optional) rest
                        [^\[\]]+?
                        \]
                            [ ]*  ## optional trailing spaces
                        $
                     )

              }ix

GOAL_NONE_REPLACE = '\1'



FIX_HEADING_RE = %r{   ^
                   [ ]*
                     =+  (?! =)
                    [ ]*
                    (?: .+?  )
                 $
              }ix


def fmtfix( txt )

   ## auto-remove match numbers
   ## txt = txt.gsub( ORD_RE, '' )

   ## auto-fix goal lines
   ## txt = txt.gsub( GOAL_NONE_RE, GOAL_NONE_REPLACE )
   ## txt = txt.gsub( GOAL_LINE_RE, GOAL_LINE_REPLACE )


   txt = fix_rounds( txt )


   txt = fix_dates( txt )

   ## replace underscore in headings with space
   ## txt = txt.gsub( FIX_HEADING_RE ) do |match|
   ##                   match.gsub( '_', ' ' )
   ##           end

  txt
end
