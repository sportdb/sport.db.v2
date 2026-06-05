

     ### experimental "compact" leg-style match format
     ##     no date/time in match line REQUIRES date_legs_header for now
     ##             (otherwise) date unknown!!




        match_line_legs
              : match_fixture  SCORE_LEGS  NEWLINE
                {
                      kwargs = { score: val[1].as_hash }.merge( val[0] )
                      @tree << MatchLineLegs.new( **kwargs )
                }
