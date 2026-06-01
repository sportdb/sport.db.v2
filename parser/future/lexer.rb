

###
##  check for magic comments
##     e.g  # teletype: true    or TELETYPE: TRUE
##             tty/teletype

MAGIC_COMMENT_RE = %r{  \A
                         [ ]*    ## optional leading spaces
                        \#+      ##  note - allow ##,###, etc. too
                         [ ]*    ## optional spaces
                           (?<magic_comment_key> tty | teletype )
                         [ ]*    ## optional spaces
                            :
                         [ ]*    ## optional spaces
                            (?<magic_comment_value> true | false )
                         [ ]*    ## optional trailing spaces
                        \z
                      }ix




####
##   flags / modes
    @teletype = false     # use magic comment - tty/teletype: true



        ##
        ###
        ##  check for magic comments
        ##     e.g  # teletype: true    or TELETYPE: TRUE
        ##             tty/teletype

        if line.start_with?('#')   ###  skip comments (& check magic comments!!)

           if (m = MAGIC_COMMENT_RE.match(line))
              magic_comment_key   = m[:magic_comment_key].downcase
              magic_comment_value = m[:magic_comment_value].downcase

              ##   turn on teletype mode
              ## e.g.  tty: true  or teletype: true
              if ['tty', 'teletype'].include?( magic_comment_key ) &&
                 ['true'].include?( magic_comment_value )
                 _info( 'magic comment - turn on teletype (tty) mode')
                 @teletype = true
              end
           end

           next
        end


        elsif @re != TABLE_MORE_RE &&  (m = HRULER_RE.match(line))
           ## note - hruler (---)
           ##          will only match if NOT in table mode!!!
           ##   otherwise
           ##      hruler always resets parser mode to std/top-level!!!
           @re = RE
           tokens_by_line << [[:HRULER, '<|HRULER|>']]
        elsif @teletype && (@re == RE && IS_TTY_LINE_RE.match(line))
            ## try experimental TELETYPE (TTY) mode!!!
            ##    note - turn on via magic comment e.g.  tty/teletype: true
            ###
            ###    move inside _tokenize_line - why? why not?


            tokens_by_line << _tokenize_tty_line( line )

            ##   note - dates such as
            ##         APR 11 or 11 APR   will trigger TELETYPE
            ###    ## check letter




        elsif buf.match?( :TEAM, :SCORE_TEAM )
            ## merge TEAM SCORE_TEAM into TEAMALT
            ##     (use TEAMENTRY or TEAMRESULT - why? why not?)
               team       = buf.next[1]
               score_team = buf.next[1]
               val =  [team + ' ' + score_team[0],  ## concat string of two tokens
                        { team: team }.merge( score_team[1] )
                      ]
               nodes << [:TEAMALT, val]
        elsif buf.match?( :TEAM, :SCORE_TEAM_PEN )
               team           = buf.next[1]
               score_team_pen = buf.next[1]
               val =  [team + ' ' + score_team_pen[0],  ## concat string of two tokens
                        { team: team }.merge( score_team_pen[1] )
                      ]
               nodes << [:TEAMALT_PEN, val]
        elsif buf.match?( :TEAM, :SCORE_TEAM_NUM )
               team           = buf.next[1]
               score_team_num = buf.next[1]
               val =  [team + ' ' + score_team_num[0],  ## concat string of two tokens
                        { team: team }.merge( score_team_num[1] )
                      ]
               nodes << [:TEAMALT_NUM, val]



  ## flatten tokens

       ###############
     ##   "hacky" (automagic) line merges (remove newline)
           ## if line start with @  - check if incl. teams

     ###
     ### quick merge lines hack
     ##    if line starts with geo-marker token @
     ##            check if line incl. TEAM
     ##           if yes, leave alone
     ##            otherwise  merge line into previous line!!
     ##       - todo/fix - handle in possibly in grammar!!!
     ##        for now match_line CAN start with @ London
     ##                 resulting in parser conflict(s)!!!
     ##    e.g.
     ##       England v Scotland
     ##          @ London
     ##          =>
     ##        England v Scotland @ London
     ##

     ##
     ##  note/todo - if INDENT / SPACES get added
     ##                adjust here
     ##   tok[0][0] == :INDENT  (or :SPACES) &&
     ##   tok[1][0] == :'@'

           if tok[0] && tok[0][0] == :'@'
                team =  tok.find { |t| t[0] == :TEAM }
                if team
                   ## do nothing - keep as is (assume match_line starting w/ @)
                else
                  ## no team(s) found in line
                  ##    remove last token (that is, NEWLINE)
                  ##   note - possibly is blank ?!  keep blank
                  tokens.pop  if tokens[-1][0] == :NEWLINE
                end
           end
