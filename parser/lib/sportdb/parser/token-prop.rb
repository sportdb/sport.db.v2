###
##  team prop mode e.g.
##
##
##    Fri Jun 14 21:00  @ München Fußball Arena, München
##     Germany  v  Scotland   5-1 (3-0)
##  (Wirtz 10' Musiala 19' Havertz 45+1' (pen.) Füllkrug 68' Can 90+3'; Rüdiger 87' (o.g.))
##
## Germany:    Neuer - Kimmich, Rüdiger, Tah [Y], Mittelstädt - Andrich [Y] (Groß 46'),
##       Kroos (Can 80') - Musiala (Müller 74'), Gündogan, Wirtz (Sane 63') -
##       Havertz (Füllkrug 63')
## Scotland:   Gunn - Porteous [R 44'], Hendry, Tierney (McKenna 78') - Ralston [Y],
##       McTominay, McGregor (Gilmour 67'), Robertson - Christie (Shankland 82'),
##       Adams (Hanley 46'), McGinn (McLean 67')


module SportDb
class Lexer


##############
#  add support for props/ attributes e.g.
#
#    Germany:    Neuer - Kimmich, Rüdiger, Tah [Y], Mittelstädt - Andrich [Y] (46' Groß),
#      Kroos (80' Can) - Musiala (74' Müller), Gündogan,
#      Wirtz (63' Sane) - Havertz (63' Füllkrug)
#    Scotland:   Gunn - Porteous [R 44'], Hendry, Tierney (78' McKenna) - Ralston [Y],
#      McTominay, McGregor (67' Gilmour), Robertson - Christie (82' Shankland),
#      Adams (46' Hanley), McGinn (67' McLean)
#
## note:  colon (:) MUST be followed by one (or more) spaces
##      make sure mon feb 12 18:10 will not match
##        allow 1. FC Köln etc.
##               Mainz 05:
##           limit to 30 chars max
##          only allow  chars incl. intl but (NOT ()[]/;)
##
##
##  note - use special \G - Matches first matching position !!!!
##     check for \G like backreference of regex tokens/parts if possible/available in ruby?



  ## (i) starting w/ letters
  ##                   note - incl./allows digits (0-9)
  ##          e.g. a1, a2000, etc.
  ##
  ## note - added back optional trailing dot (.) for abbrev. word  !!!
  PROP_KEY_WORD_ = %r{
                           \p{L}
                             [\p{L}\d]*
                             \.?
                    }ix

  ## note - incl. optional dot or numsign e.g. 1. or 1°
  PROP_KEY_NUM_ = %r{
                              \d+
                              [.°]?
                   }ix

  ## e.g. 1A, 1FC etc.
  ##  note - no trailing dot (.) for now - check if any cases exist in real world
  PROP_KEY_NUMALPHA_ = %r{
                              \d+
                              \p{L}
                               [\p{L}\d]*
                     }ix





  START_WITH_PROP_KEY_RE = %r{
                   \A         ## note - MUST start line; leading spaces optional (eat-up)
                 (?<prop_key>
                     [ ]*     ##  optional leading spaces
                   (?<key>
                       (?:
                           ## (i) starting w/ letters
                             #{PROP_KEY_WORD_}

                           ## (ii) starting w/ number
                           ##  e.g. 1fc, 1a,
                           | #{PROP_KEY_NUMALPHA_}
                           ##      followed by optional dot) and
                           ##                  optional space
                           ##      MUST be follow by letter (a to z)!!!!
                           ##   eg. 1[ fc], 1.[ fc], 1.[fc],  etc.
                           | #{PROP_KEY_NUM_}   (?= [ ]? \p{L})
                       )
                       (?:
                           ## connectors  - note - no dot (.), must match with abbrev word or num!!
                            (?: ## (i)   single space or WITHOUT surrounding spaces!! - slash (/), dash (-)
                                ##     e.g. do NOT match   one - two     or one / two
                                ##                        only one-two   or  one/two

                                  [ /-]

                                ## (ii)     surrounded by leading or trailing optional space
                                ##            c & a, etc.
                                ##            d'ivoire, d' ivoire
                                ##            borusia 'gladbach etc.
                                ##              exclude space ' space - why? why not? (or ignore for now)
                                ##
                                ##    check for quotes  ('') - not realy supported here
                                ##              e.g. leading or trailing ' will NOT match

                                 |  [ ]? & [ ]?
                                 |  [ ]? '
                                 |  ' [ ]?

                                #### (iii)
                                ##   note - special "hack"  to connect WITHOUT space
                                ##     for   Union 1.FC  and SKN St.Pölten or St.Pölten
                                ##       connects      1.FC      => NUM+WORD
                                ##                     1°Mayo    => NUM+WORD
                                ##                     St.Pölten => ABBREV+WORD
                                ##
                                ## note - match WITHOUT (space) connector
                                ##                  1.FC  (Union 1.FC Stein)
                                ##               [WORD: "Union"], [NUM: "1."], [WORD: "FC"]
                                ##                  St.Pölten (SKN St.Pölten)
                                ##                [WORD: "SKN"], [ABBREV: "St."], [WORD: "Pölten"]
                                |   (?<=  [.°] )
                                    (?=  \p{L})
                            )
                             (?:
                                   #{PROP_KEY_NUMALPHA_}
                                |  #{PROP_KEY_NUM_}
                                |  #{PROP_KEY_WORD_}
                               )
                       )*
                      )       ## close <key> capture
                    [ ]*?     ## slurp trailing spaces
                     :

                ## positive lookahead (must be followed by space!!)
                ##     or allow end-of-line too
                    (?= [ ]+|$)
                   )  ## close <prop_key> capture
                 }ix





################
##     todo/check - use token for card short cuts?
##                if m[:name] == 'Y'
##                 [:YELLOW_CARD, m[:name]]
##               elsif m[:name] == 'R'
##                 [:RED_CARD, m[:name]]
##           -  [Y], [R], [Y/R]  Yellow-Red Card
##    check if minutes possible inside [Y 46']
##     add [c] for captain too


##  [c] or [C] for marking player as captain
##   support [y ] too - or require Y - why? why not?
  INLINE_CAPTAIN = %r{ (?<inline_captain>
                           \[ [cC] \]
                       )}x

  INLINE_YELLOW  = %r{ (?<inline_yellow>
                          \[ [yY]
                              ## optional minute
                              (?: [ ]+
                                (?<minute> \d{1,3})
                                   '?
                                (?:
                                   \+
                                   (?<offset>\d{1,2})
                                    '?
                                )?
                              )?
                          \]
                     )}x

  INLINE_RED  = %r{ (?<inline_red>
                          \[ [rR]
                              ## optional minute
                              (?: [ ]+
                                (?<minute> \d{1,3})
                                   '?
                                (?:
                                   \+
                                   (?<offset>\d{1,2})
                                    '?
                                )?
                              )?
                          \]
                     )}x

  INLINE_YELLOW_RED  = %r{ (?<inline_yellow_red>
                          \[ (?:y/r |
                                Y/R  )
                              ## optional minute
                              (?: [ ]+
                                (?<minute> \d{1,3})
                                   '?
                                (?:
                                   \+
                                   (?<offset>\d{1,2})
                                    '?
                                )?
                              )?
                          \]
                     )}x




### simple prop key for inline use e.g.
###    Coach:  or Trainer:  or ...  add more here later

  PROP_KEY_INLINE_RE = %r{
                    \b
                 (?<prop_key>    ## note: use prop_key (NOT prop_key_inline or such)
                   (?<key>
                       \p{L}+
                   )
                    ## note - NO spaces allowed for key for now!!!
                     :
                    ## possitive lookahead (must be followed by space!!)
                    (?=[ ]+)
                   )
                 }ix



## note allow underscore inline e.g.
##  5_000
## discuss/check - allow space inline (e.g. 5 000) - why? why not?

PROP_NUM_RE = %r{
             \b
              (?<num>
                  (?<value> [0-9]+
                             (?: _ [0-9]+)*
                  )
              )
             \b
            }x


### todo/fix - allow more chars in enclosed name  - why? why not?
##                     e.g.  (') - Cote D'Ivore etc.
##  change to PAREN_NAME or PARENTHESIS or such - why? why not?
ENCLOSED_NAME_RE = %r{
                 (?<enclosed_name>
                    \(
                   (?<name>
                       \p{L}+
                       (?:
                          [ ]
                            \p{L}+
                       )*
                   )
                     \)
                 )
         }ix






end  # class Lexer
end  # module SportDb