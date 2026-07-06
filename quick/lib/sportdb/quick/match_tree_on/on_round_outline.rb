module SportDb
class MatchTree



  def on_round_outline( node )
    _trace( "on round outline: >#{node}<" )

    ## always reset dates - why? why not?
    ##    note - needs last_date for year
    ##         track last_year with extra variable

    name  = node.outline
    level = node.level


      ####
      # check for "old" group header in ("automagic") round outline for now
      ##
      ##  todo/fix - use only names from group def for lookup/is_group match!!!
      ##    do NOT use (generic) regex!!
      if level == 1 && _is_group?( name )
        _trace( "on group header: >#{node}<" )

        group = @groups[ name ]

        if group
          # set group for matches
          @last_group = group
            # note: group header resets (last) round  (allows, for example):
            #  e.g.
            #  Group Playoffs/Replays       -- round header
            #    team1 team2                -- match
            #  Group B                      -- group header
            #    team1 team2 - match  (will get new auto-matchday! not last round)
          @last_round     = nil
          return  ## note - return here; do NOT fall through to std round processing!
        else
          puts "!! WARN - no group def found for >#{name}<; will use a (plain) round"
        end
      end  ## is_group?


      ##
      ## todo/fix - also reset round name levels on heading 1/2/3 etc.
      ##                why? why not?

      if level == 1
        @last_round_name1 = name
        @last_round_name2 = nil
        @last_round_name3 = nil
      elsif level == 2
        @last_round_name2 = name
        @last_round_name3 = nil
        name = [@last_round_name1, name].join( ', ' )
      elsif level == 3
        @last_round_name3 == name
        name = [@last_round_name1, @last_round_name2, name].join( ', ')
      else
         puts "!! ERROR - unsupported round outline level #{level}; use 1-3 - sorry"
         exit 1
      end


      round = @rounds[ name ]
      if round.nil?    ## auto-add / create if missing
        round = Round.new( name: name )
        @rounds[ name ] = round
      end

      @last_round = round
      @last_group = nil   # note: always reset group to no group - why? why not?

      ## todo/fix/check
      ##  make round a scope for date(time) - why? why not?
      ##   reset date/time e.g. @last_date = nil !!!!
  end



###
##  helpers

##
##  note - do NOT match group phase or group playoff or such
##            for now only works for group a,b,c or group 1, group 2, etc.

  GROUP_RE = %r{\A
                    Group [ ] (?:
                                   [a-z]
                                 | \d+
                               )
              \z}ix


  def _is_group?( text )
    ## use regex for match
    GROUP_RE.match?( text )
  end



end ## class MatchTree
end ##  module SportDb
