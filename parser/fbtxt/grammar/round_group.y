
        ######
        # e.g   Group A  |    Germany   Scotland     Hungary   Switzerland
        ##  or  Group A  :    Germany, Scotland, Hungary, Switzerland

        group_def_sep :  '|' | ':'

        group_def
              :   GROUP_DEF group_def_sep   team_values   NEWLINE
                  {
                      @tree << GroupDef.new( name:  val[0].value,
                                             teams: val[2] )
                  }

        team_values
              :   TEAM                       { result = val
                                               ## e.g. val is ["Austria"]
                                             }
              |   team_values TEAM           { result.push( val[1].value )  }
              |   team_values ',' TEAM       { result.push( val[2].value )  }




        ####
        ##   round ouline -  note: is an all-in-one line/text
        ##                          NOT tokens separated by comma(,) or dash(-)
        round_outline :    ROUND_OUTLINE NEWLINE
                              {
                                  kwargs = val[0].value
                                  @tree << RoundOutline.new( **kwargs )
                              }

        #####
        # e.g.  Matchday 1  |  Fri Jun 14 - Tue Jun 18
        #       Matchday 1  :  Fri Jun 14 - Tue Jun 18
        round_def_sep :  ':' | '|'

        ##
        ##  note - round_def is also a round_outline
        ##    todo/fix - allow a list of dates & durations
        ##           not just single date or duration!!!
        round_def
             :  ROUND_DEF round_def_sep   round_date_opts   NEWLINE
                  {
                      kwargs = { name: val[0].value }.merge( val[2] )
                      @tree << RoundDef.new( **kwargs )

                      ## auto-add RoundOutline here - why? why not?
                      ##    or handle "implicit" round_outline
                      ##     in tree walker?
                      @tree << RoundOutline.new( outline: val[0].value, level: 1 )
                  }

       round_date_opts  :   DATE        { result = { date: val[0].value } }
                         |  DURATION     { result = { duration: val[0].value } }
