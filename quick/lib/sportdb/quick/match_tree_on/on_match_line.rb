module SportDb
class MatchTree



  def on_match_line( node )
    logger.debug( "on match: >#{node}<" )

    ## collect (possible) nodes by type
    num    = nil
    num = node.num   if node.num

    date   = nil
    date =  _build_date( m: node.date[:m],
                         d: node.date[:d],
                         y: node.date[:y],
                         yy: node.date[:yy],
                         wday: node.date[:wday],
                         start: @start,
                         last_year: true )   if node.date

    ## note - there's no time (-only) type in ruby
    ##  use string (e.g. '14:56', '1:44')
    ##   use   01:44 or 1:44 ?
    ##  check for 0:00 or 24:00  possible?
    time   = nil
    if node.time
       time   =  ('%d:%02d' % [node.time[:h], node.time[:m]])
       ## check for timezone
       time += " #{node.time[:timezone]}"   if node.time[:timezone]
    end



    ## todo/fix -
    ##   keep  time & time_local as pairs for @last_time/@last_time_local
    ##    - check for timezone
    ##      incl. timezone in time (string) - why? why not?
    time_local = nil
    if node.time_local
      time_local  =  ('%d:%02d' % [node.time_local[:h], node.time_local[:m]])
      time_local +=  " #{node.time_local[:timezone]}"   if node.time_local[:timezone]
    end


    ### todo/fix
    ##    add keywords (e.g. ht, ft or such) to Score.new - why? why not?
    ##     or use new Score.build( ht:, ft:, ) or such - why? why not?
    ## pp score
    score  = nil
    score = node.score   if node.score

    ## if node.score.is_a?(Array)
    ##    ## assume "undefined" score
    ##    score = node.score
    ##  else  ## (default) assume Hash
    ##     # ht = node.score[:ht] || [nil,nil]
    ##     # ft = node.score[:ft] || [nil,nil]
    ##     # et = node.score[:et] || [nil,nil]
    ##     # p  = node.score[:p]  || [nil,nil]
    ##     # values = [*ht, *ft, *et, *p]
    ##     # pp values
    ##     ## pp node.score
    ##    score = node.score
    ##  end
    ## end


    status = nil
    status =  node.status   if node.status   ### assume text for now
    ## if node_type == :status  # e.g. awarded, canceled, postponed, etc.
    ##  status = node[1]
    #
    ## todo - add    ## find (optional) match status e.g. [abandoned] or [replay] or [awarded]
    ##                                   or [cancelled] or [postponed] etc.
    ##    status = find_status!( line )   ## todo/check: allow match status also in geo part (e.g. after @) - why? why not?



    team1 = node.team1
    team2 = node.team2

    @teams[ team1 ] += 1
    @teams[ team2 ] += 1


    if node.header ## note - date/time for matches (w/ header) CANNOT get inherited!!
       @last_date = nil
       @last_time = nil
    else  ## no (match header), use date/time inheritance rules
      ###
      # check if date found?
      #   note: ruby falsey is nil & false only (not 0 or empty array etc.)
      if date
        ### check: use date_v2 if present? why? why not?
        @last_date = date    # keep a reference for later use
        @last_time = nil
        # @last_time = nil
      else
        date = @last_date    # no date found; (re)use last seen date
      end

      if time
        @last_time = time
      else
        time = @last_time
      end
    end



    group =  nil
    group =  @last_group  if @last_group

    round = nil
    round =  @last_round  if @last_round


    ### try auto-fill round
    ##    find (first) matching round by date if rounds / matchdays defined
    ##   if not rounds / matchdays defined - YES, allow matches WITHOUT rounds!!!
    if date && round.nil?
        if @rounds.size > 0
          @rounds.values.each do |round_rec|
            ## note: convert date to date only (no time) with to_date!!!
            if (round_rec.start_date && round_rec.end_date) &&
               (date.to_date >= round_rec.start_date &&
               date.to_date <= round_rec.end_date)
              round = round_rec
              break
            end
          end
          if round.nil?
            ## todo/fix - issue a warning (do NOT stop)
            puts "!! PARSE ERROR - no matching round found for match date:"
            pp date
            exit 1
          end
        end
    end


    ## todo/check: scores are integers or strings?

    ## todo/check: pass along round and group refs or just string (canonical names) - why? why not?

    ## split date in date & time if DateTime
=begin
    time_str = nil
    date_str = nil
    if date.is_a?( DateTime )
        date_str = date.strftime('%Y-%m-%d')
        time_str = date.strftime('%H:%M')
    elsif date.is_a?( Date )
        date_str = date.strftime('%Y-%m-%d')
    else  # assume date is nil
    end
=end

    time_str       = nil
    time_local_str = nil
    date_str       = nil

    date_str       = date.strftime('%Y-%m-%d')  if date
    time_str       = time           if date && time
    time_local_str = time_local     if date && time_local



    ground   = nil
    ground = node.geo  if node.geo

    ## attendance
    att = nil
    att =  node.att   if node.att


    @matches << Match.new( num:        num,
                           date:       date_str,
                           time:       time_str,
                           time_local: time_local_str,
                           team1:    team1,  ## note: for now always use mapping value e.g. rec (NOT string e.g. team1.name)
                           team2:    team2,  ## note: for now always use mapping value e.g. rec (NOT string e.g. team2.name)
                           score:    score,
                           round:    round ? round.name : nil,  ## note: for now always use string (assume unique canonical name for event)
                           group:    group ? group.name : nil,  ## note: for now always use string (assume unique canonical name for event)
                           status:   status,
                           ground:   ground,
                           att:      att )
    ### todo: cache team lookups in hash?
  end


end ## class MatchTree
end ##  module SportDb
