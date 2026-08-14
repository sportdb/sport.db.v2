##
# move (simpler) struct version inline to MatchTree for now
#
module Fbtxt
 module Model



class Match

  attr_reader :num,
              :date,
              :time,
              :time_local,
              :team1,     :team2,      ## todo/fix: use team1_name, team2_name or similar - for compat with db activerecord version? why? why not?
              :score,
              :round,     ## todo/fix:  use round_num or similar - for compat with db activerecord version? why? why not?
              :group,
              :status,    ## e.g. replay, cancelled, awarded, abadoned, postponed, etc.
              :ground,       ## (optional) add as text line for now (incl. city, timezone etc.)
              :att            ## (optional) attendance as (integer) number


  ## e.g. support (flat/undefined) [], or (nested/paired) [[],[]]
  attr_accessor :goals      ## todo/fix: make goals like all other attribs!!

###
#  add details match (report) info
##          lineup,bench,subs,bookings(y/yr/r/etc.)
  attr_accessor :lineup  ## incl. starter/bench/subs!!!
  attr_accessor :bookings    ## use cards - why? why not?

  attr_accessor :referees

  attr_accessor :penalties


  def initialize( **kwargs )
    update( **kwargs )  unless kwargs.empty?
  end


  def update( **kwargs )
    @num      = kwargs[:num]     if kwargs.has_key?( :num )

    ## note: check with has_key?  because value might be nil!!!
    @date       = kwargs[:date]        if kwargs.has_key?( :date )
    @time       = kwargs[:time]        if kwargs.has_key?( :time )
    @time_local = kwargs[:time_local]  if kwargs.has_key?( :time_local )

    ## todo/fix: use team1_name, team2_name or similar - for compat with db activerecord version? why? why not?
    @team1    = kwargs[:team1]    if kwargs.has_key?( :team1 )
    @team2    = kwargs[:team2]    if kwargs.has_key?( :team2 )

    ## note: round is a string!!!  e.g. '1', '2' for matchday or 'Final', 'Semi-final', etc.
    ##   todo: use to_s - why? why not?
    @round    = kwargs[:round]    if kwargs.has_key?( :round )
    @group    = kwargs[:group]    if kwargs.has_key?( :group )
    @status   = kwargs[:status]   if kwargs.has_key?( :status )

    @ground   = kwargs[:ground]   if kwargs.has_key?( :ground )
    @att      = kwargs[:att]      if kwargs.has_key?( :att )

    ## check/expects all-in-one score struct for convenience!!!
    @score    = kwargs[:score]     if kwargs.has_key?( :score )

    self   ## note - MUST return self for chaining
  end



def as_json
  #####
  ##  note - use string keys (NOT symbol for data keys)
  ##            for easier json compatibility
  data = {}

  ## check round
  if @round
    data['round'] = if round.is_a?( Integer )
                      "Matchday #{@round}"
                    else ## assume string
                      @round
                    end
  end


  data['num'] = @num    if @num


  if @date
    ## assume 2020-09-19 date format!!
    data['date']  = @date.is_a?( String ) ? @date : @date.strftime('%Y-%m-%d')

    data['time']        = @time           if @time
    data['time_local']  = @time_local     if @time_local
  end


  data['team1'] =  @team1.is_a?( String ) ? @team1 : @team1.name

  ## note - for match status bye  team2 is nil!!!
  ##           e.g.     Queen's Park       bye
  ##                    Wanderers          bye
  ##   todo/check - keep bye as a match - why? why not?
  ##                      has no date/time & venue & score etc.
  if @team2
    data['team2'] =  @team2.is_a?( String ) ? @team2 : @team2.name
  end

  ## note - score might be
  ##           1) array e.g. [0,1]   -- e.g. uses reported key internally
  ##           2) hash  e.g. { 'ft' [0,1] } etc.
  ##  note - w/o (walkout)  do NOT add empty score

   ## note:
   ##   use/assume full-time (ft) if reported - why? why not?
   ##     in future check for score note or such
   ##      to  use "plain" array or such - why? why not?

  data['score'] = @score.as_json      if @score



  ### check for goals
  if @goals.is_a?(Array) && @goals.size > 0
    data['goals1'] = []
    data['goals2'] = []

    @goals.each do |goal|
         if goal.team == 1
            data['goals1']  << goal.as_json
          else  ## assume 2  (or better raise except if NOT 2)
            data['goals2']  << goal.as_json
          end
     end  # each goal
  end

  ### check for penalties (shootout)
  if @penalties.is_a?(Array) && @penalties.size > 0
     data['penalties'] = @penalties.as_json
  end



  data['status'] = @status  if @status

  data['group']  = @group   if @group

  if @ground
       ## note: might be array of string e.g. ['Wembley', 'London']
       ##
       ##  todo/check - auto-join to string - why? why not?
       ##                   e.g.  ['Wembley', 'London']
       ##                     to   'Wembley, London'
       ##   note - auto-join geo tree for now
       data['ground'] = @ground.join(', ')
  end

  data['attendance'] = @att   if @att


###
#  check for match (report) details
#    quick & dirty first try/version/dump
#      refine (serialize) format later
    if @lineup.is_a?(Array) && @lineup.size > 0
        data['lineup'] = @lineup.as_json
    end


    if @bookings.is_a?(Array) && @bookings.size > 0
       if @bookings[0].empty? && @bookings[1].empty?
          ##  skip empty bookings
          ## "bookings": [[], []]
       else
         data['bookings'] = @bookings.as_json
       end
    end


    if @referees.is_a?(Array) && @referees.size > 0
        data['referees'] = @referees.as_json
    end


  data
end
end  # class Match



end # module Model
end # module Fbtxt