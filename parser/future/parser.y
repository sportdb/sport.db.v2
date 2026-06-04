
  element
    :
    | hruler
    | table_line


      table_line
           : TABLE_HEADING NEWLINE { @tree << TableHeading.new( text: val[0]) }
           | TABLE_LINE NEWLINE    { @tree << TableLine.new( text: val[0]) }
           | TABLE_NOTE NEWLINE    { @tree << TableNote.new( text: val[0]) }
           | TABLE_DIVIDER NEWLINE { @tree << TableDivider.new( text: val[0]) }

    hruler
            : HRULER NEWLINE   { @tree << HRuler.new  }


      ######
        ### (experimental) alternate style with "split" score
        match_line_alt  : match_line_alt_props
                           {
                             kwargs = {}.merge( val[0] )
                             @tree << MatchLine.new( **kwargs )
                           }

       ## use match_line_alt_props   for reuse (gets you all props
       ##                          BUT will NOT create MatchLine)
        match_line_alt_props
            : match_alt_inline NEWLINE
                              {
                                  result = {}.merge( val[0] )
                              }
            | match_alt_block NEWLINE opt_status_line
                           {
                               result = {}.merge( val[0], val[2] )
                           }


        opt_status_line
                 :  ## optional; empty
                    { result = {}  }
                 | STATUS NEWLINE
                    {
                      puts "status_line:"
                      pp val[0]
                      result = val[0][1]
                    }





        ### block style  one team record/entry per line
        match_alt_block
            : TEAMALT NEWLINE TEAMALT
                   {
                           ## puts "debug match_alt reduce:"
                           ## pp val[0]
                           ## pp val[2]

                           ## assume ht/ft
                           ## or let's use [[0,1],[1,2]] - why? why not?
                           score_team1 = val[0][1][:score]
                           score_team2 = val[2][1][:score]


                           score =  [[score_team1[0], score_team2[0]],
                                     [score_team1[1], score_team2[1]]]

                           result = { team1: val[0][1][:team],
                                      team2: val[2][1][:team],
                                      score: score
                                    }

                           ## puts "  result:"
                           ## pp result
                   }
          | TEAMALT_PEN  NEWLINE  TEAMALT_PEN
                   {
                           ## assume pen for score_ii
                           ##    score_i might be ft or et???
                           ## or let's use [[0,1],[1,2]] - why? why not?
                           score_team1 = val[0][1][:score]
                           score_team2 = val[2][1][:score]

                           score =  { '_': [score_team1[0], score_team2[0]],
                                      pen: [score_team1[1], score_team2[1]]
                                    }

                           result = { team1: val[0][1][:team],
                                      team2: val[2][1][:team],
                                      score: score
                                    }
                   }
               | TEAMALT_NUM NEWLINE TEAMALT_NUM
                   {
                           score_team1 = val[0][1][:score]
                           score_team2 = val[2][1][:score]

                           score =  [score_team1, score_team2]

                           result = { team1: val[0][1][:team],
                                      team2: val[2][1][:team],
                                      score: score
                                    }
                   }
               | TTY_TEXT TTY_NUM NEWLINE TTY_TEXT TTY_NUM
                   {
                           result = { team1: val[0],
                                      team2: val[3],
                                      score: [val[1], val[4]]
                                    }
                   }




        ## rename to compact or ??
        ##     all-in-one line style
        match_alt_inline
           : TEAMALT TEAMALT
                   {
                           ## assume ht/ft
                           ## or let's use [[0,1],[1,2]] - why? why not?
                           score_team1 = val[0][1][:score]
                           score_team2 = val[1][1][:score]

                           score =  [[score_team1[0], score_team2[0]],
                                     [score_team1[1], score_team2[1]]]

                           result = { team1: val[0][1][:team],
                                      team2: val[1][1][:team],
                                      score: score
                                    }
               }
           | TEAMALT_PEN TEAMALT_PEN
                   {
                           ## assume pen for score_ii
                           ##    score_i might be ft or et???
                           ## or let's use [[0,1],[1,2]] - why? why not?
                           score_team1 = val[0][1][:score]
                           score_team2 = val[1][1][:score]

                           score =  { '_': [score_team1[0], score_team2[0]],
                                      pen: [score_team1[1], score_team2[1]]
                                    }

                           result = { team1: val[0][1][:team],
                                      team2: val[1][1][:team],
                                      score: score
                                    }
                   }
           | TEAMALT_NUM TEAMALT_NUM
                   {
                           score_team1 = val[0][1][:score]
                           score_team2 = val[1][1][:score]

                           score =  [score_team1, score_team2]

                           result = { team1: val[0][1][:team],
                                      team2: val[1][1][:team],
                                      score: score
                                    }
                   }
          | TTY_TEXT TTY_NUM TTY_TEXT TTY_NUM
                   {
                           result = { team1: val[0],
                                      team2: val[2],
                                      score: [val[1], val[3]]
                                    }
                   }
