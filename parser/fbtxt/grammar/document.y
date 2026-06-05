
       document   : {}     # note - allow empty documents - why? why not?
                  | elements

       elements  : element
                 | elements element


       element
          : heading       # e.g. h1,h2,h3, etc.
          | group_def
          | round_def
          | round_outline
          | date_header
          | match_line_with_header
          | match_line

          ## add support for "compact" match legs (1st leg, 2nd leg, aggregate)
          | date_header_legs
          | match_line_legs

          ## todo/fix - change (inline) NOTE to INLINE_NOTE
          ##              and only use NOTE for "standalone" NOTE (lines)
          | note_line
          | nota_bene

          ## check - change goal_lines to MUST follow match_line - why? why not?
          | goal_lines
          | goal_lines_alt     ## allow differnt style/variant e.g. 1-0 Player
                               ##  starting with score
          | goal_lines_compat


          | lineup_lines
          | yellowcard_lines   ## use _line only - why? why not?
          | redcard_lines
          | penalties_lines   ## rename to penalties_line or ___ - why? why not?
          | referee_line
          | attendance_line

          | BLANK        ##  was empty_line
             {
               _trace( "REDUCE BLANK" )
               @tree << BlankLine.new
             }

          | error      ## todo/check - move error sync up to elements - why? why not?
              { puts "!! skipping invalid content (trying to recover from parse error):"
                pp val[0]
                ##  note - do NOT report recover errors for now
                ##  @errors << "parser error (recover) - skipping #{val[0].pretty_inspect}"
              }

          ### use   error NEWLINE - why? why not?
          ##           will (re)sync on NEWLINE?


       heading
           : H1 NEWLINE   {  @tree << Heading1.new( text: val[0].value)  }
           | H2 NEWLINE   {  @tree << Heading2.new( text: val[0].value)  }
           | H3 NEWLINE   {  @tree << Heading3.new( text: val[0].value)  }


        note_line
            : NOTE NEWLINE  { @tree << NoteLine.new( text: val[0].value) }

        nota_bene
            : NOTA_BENE NEWLINE    { @tree << NotaBene.new( text: val[0].value) }




####
## shared helpers

          opt_blank_lines :     ## optional; empty
                          | blank_lines

          blank_lines  : BLANK
                       | blank_lines BLANK



     ##  note - not used for now
     ##    opt_newline :  ## empty; optional
     ##                | NEWLINE
