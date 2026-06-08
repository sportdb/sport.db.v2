

        penalties_lines : PROP_PENALTIES penalties_body PROP_END NEWLINE
                            {
                               @tree << PenaltiesLine.new( penalties: val[1] )
                            }



        penalty_sep     :  ','
                        |  ',' NEWLINE
                        |  ';'
                        |  ';' NEWLINE

        penalties_body  :  penalty                             {  result = val  }
                        |  penalties_body penalty_sep penalty  {  result.push( val[2] )  }



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
