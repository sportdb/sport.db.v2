
     ##
        ##  add a GOALS_NONE_RIGHT too  e.g.
        ##    Jr. 43'; -
        ##    Jr. 43'; none
        ##    Jr. 43'; ∅
        ##
        ##  fix-fix-fix - change GOALS_NONE to GOALS_NONE_LEFT - why? why not?

        goal_lines_body : goals                  {  result = { goals1: val[0],
                                                               goals2: [] }
                                                 }
                        | goals GOALS_NONE_RIGHT {  result = { goals1: val[0],
                                                               goals2: [] }
                                                 }
                        | GOALS_NONE goals      {  result = { goals1: [],
                                                              goals2: val[1] }
                                                }
                        | goals goals_sep goals {  result = { goals1: val[0],
                                                              goals2: val[2] }
                                                }
