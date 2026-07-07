module Fbtxt
class MatchTree


  def on_round_def( node )
    _trace( "on round def: >#{node}<" )

    ## e.g. [[:round_def, "Matchday 1"], [:duration, "Fri Jun 14 - Tue Jun 18"]]
    ##      [[:round_def, "Matchday 2"], [:duration, "Wed Jun 19 - Sat Jun 22"]]
    ##      [[:round_def, "Matchday 3"], [:duration, "Sun Jun 23 - Wed Jun 26"]]

    name  = node.name
    # NB: use extracted round name for knockout check
    # knockout_flag = is_knockout_round?( name )


    ##
    ##  note - do NOT update @last_year on round def dates!!
    ##              only update for running dates in matches!!

    if node.date
        start_date = end_date = _build_date( m: node.date[:m],
                                             d: node.date[:d],
                                             y: node.date[:y],
                                             yy: node.date[:yy],
                                             wday: node.date[:wday],
                                              start: @start,
                                              last_year: false )
    elsif node.duration
      ## reuse year in start date e.g. July 26-27 1930
      ##                               July 26 [1930], [July] 27 1930
      start_date  = _build_date( m: node.duration[:start][:m],
                                 d: node.duration[:start][:d],
                                 y: node.duration[:start][:y]   || node.duration[:end][:y],
                                 yy: node.duration[:start][:yy] || node.duration[:end][:yy],
                                 wday: node.duration[:start][:wday],
                                   start: @start,
                                   last_year: false )

      ## reuse month in end date e.g.  July 26-27
      ##                               July 26, [July] 27
      end_date    = _build_date( m: node.duration[:end][:m] || node.duration[:start][:m],
                                 d: node.duration[:end][:d],
                                 y: node.duration[:end][:y],
                                 yy: node.duration[:end][:yy],
                                 wday: node.duration[:end][:wday],
                                   start: @start,
                                   last_year: false )
    else
       puts "!! PARSE ERROR - expected date or duration for round def; got:"
       pp node
       exit 1
    end

    # note: - NOT needed; start_at and end_at are saved as date only (NOT datetime)
    #  set hours,minutes,secs to beginning and end of day (do NOT use default 12.00)
    #   e.g. use 00.00 and 23.59
    # start_at = start_at.beginning_of_day
    # end_at   = end_at.end_of_day

    # note: make sure start_at/end_at is date only (e.g. use start_at.to_date)
    #   sqlite3 saves datetime in date field as datetime, for example (will break date compares later!)

    # note - _build_date always returns Date for now - no longer needed!!
    # start_date = start_date.to_date
    #  end_date   = end_date.to_date




    _trace( "    start_date: #{start_date}" )
    _trace( "    end_date:   #{end_date}" )
    _trace( "    name:    >#{name}<" )

    round = Round.new( name:       name,
                       start_date: start_date,
                       end_date:   end_date,
                       auto:       false )

    @rounds[ name ] = round
  end


end ## class MatchTree
end ##  module Fbtxt
