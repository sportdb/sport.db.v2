

        penalties_lines : PROP_PENALTIES penalties_body PROP_END
                            {
                               @tree << PenaltiesLine.new( penalties: val[1] )
                            }



        penalty_sep     :  ','

        opt_penalty_sep :   /* empty */    {  }     ## optional
                        |  penalty_sep



        penalties_team_sep   :  ';'
                             |  PENALTIES_SEP_ALT


         #####
         ##  note
         ##     (i)  []          -  single line (no separator)
         ##     (ii) [[],[]]     -  nested team1/team2 (separator required)

         penalties_body : penalties                                 { result =  val[0]           }
                        | penalties  penalties_team_sep  penalties  { result = [val[0], val[2]]  }



        penalties  :  penalty                             {  result = val  }
                   |  penalties opt_penalty_sep penalty   {  result.push( val[2] )  }


        penalty         :  SCORE PROP_NAME
                              {
                                 result = Penalty.new( score: val[0].as_ary,
                                                       name:  val[1].as_str )
                              }
                        |  SCORE PROP_NAME ENCLOSED_NAME
                               {
                                 result = Penalty.new( score: val[0].as_ary,
                                                       name:  val[1].as_str,
                                                       note:  val[2].as_str )
                               }
                        | PROP_NAME
                               {
                                 result = Penalty.new( name: val[0].as_str )
                               }
                        |  PROP_NAME ENCLOSED_NAME        ## e.g. (save), (post), etc
                               {
                                 result = Penalty.new( name: val[0].as_str,
                                                       note: val[1].as_str )
                               }
