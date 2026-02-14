
module Sports


class Match


### note - use inline Score class Match::Score - why? why not?
##      note - score might internally be an array [2,3]
##                 or hash { ft:, } etc.


## note - score for now might be
##            1) array e.g. [1,0] or []
##            2)  hash  e.g. { ft: [1,0] } etc.

  attr_reader :num,
              :date,
              :time,
              :team1,     :team2,      ## todo/fix: use team1_name, team2_name or similar - for compat with db activerecord version? why? why not?
              :score,  
              :winner,    # return 1,2,0   1 => team1, 2 => team2, 0 => draw/tie
              :round,     ## todo/fix:  use round_num or similar - for compat with db activerecord version? why? why not?
              :leg,      ## e.g. '1','2','3','replay', etc.   - use leg for marking **replay** too - keep/make leg numeric?! - why? why not?
              :stage,
              :group,
              :status,    ## e.g. replay, cancelled, awarded, abadoned, postponed, etc.
              :conf1,    :conf2,      ## special case for mls e.g. conference1, conference2 (e.g. west, east, central)
              :country1, :country2,    ## special case for champions league etc. - uses FIFA country code
              :comments,
              :league,      ## (optinal) added as text for now (use struct?)
              :ground,       ## (optional) add as text line for now (incl. city, timezone etc.)
              :timezone,      ## (optional) as a string
              :att            ## (optional) attentance as (integer) number

  attr_accessor :goals  ## todo/fix: make goals like all other attribs!!


  def initialize( **kwargs )
    @score = []
    ## @score1,    @score2    = [nil,nil]  ## full time
    ## @score1i,   @score2i   = [nil,nil]  ## half time (first (i) part)
    ## @score1et,  @score2et  = [nil,nil]  ## extra time
    ## @score1p,   @score2p   = [nil,nil]  ## penalty
    ## @score1agg, @score2agg = [nil,nil]  ## full time (all legs) aggregated


    update( **kwargs )  unless kwargs.empty?
  end


  #################################################
  ###  "legacy"  attribute readers
  ##            :score1,    :score2,     ## full time
  ##            :score1i,   :score2i,    ## half time (first (i) part)
  ##            :score1et,  :score2et,   ## extra time
  ##            :score1p,   :score2p,    ## penalty
  ##            :score1agg, :score2agg,  ## full time (all legs) aggregated
  def score1()  score.is_a?(Array)  ?   score[0] : (score[:ft]||[])[0]; end
  def score2()  score.is_a?(Array)  ?   score[1] : (score[:ft]||[])[1]; end

  def score1i()  score.is_a?(Array)  ?   nil : (score[:ht]||[])[0]; end
  def score2i()  score.is_a?(Array)  ?   nil : (score[:ht]||[])[1]; end
  
  def score1et() score.is_a?(Array)  ?   nil : (score[:et]||[])[0]; end
  def score2et() score.is_a?(Array)  ?   nil : (score[:et]||[])[1]; end

  def score1p()  score.is_a?(Array)  ?   nil : (score[:p]||[])[0]; end
  def score2p()  score.is_a?(Array)  ?   nil : (score[:p]||[])[1]; end

  def score1agg() score.is_a?(Array)  ?   nil : (score[:agg]||[])[0]; end
  def score2agg() score.is_a?(Array)  ?   nil : (score[:agg]||[])[1]; end

## def score
##    Score.new( @score1i,   @score2i,    ## half time (first (i) part)
##               @score1,    @score2,     ## full time
##               @score1et,  @score2et,   ## extra time
##               @score1p,   @score2p )   ## penalty
##  end


  

  def update( **kwargs )
    @num      = kwargs[:num]     if kwargs.has_key?( :num )

    ## note: check with has_key?  because value might be nil!!!
    @date     = kwargs[:date]     if kwargs.has_key?( :date )
    @time     = kwargs[:time]     if kwargs.has_key?( :time )

    ## todo/fix: use team1_name, team2_name or similar - for compat with db activerecord version? why? why not?
    @team1    = kwargs[:team1]    if kwargs.has_key?( :team1 )
    @team2    = kwargs[:team2]    if kwargs.has_key?( :team2 )

    @conf1    = kwargs[:conf1]    if kwargs.has_key?( :conf1 )
    @conf2    = kwargs[:conf2]    if kwargs.has_key?( :conf2 )
    @country1 = kwargs[:country1]  if kwargs.has_key?( :country1 )
    @country2 = kwargs[:country2]  if kwargs.has_key?( :country2 )

    ## note: round is a string!!!  e.g. '1', '2' for matchday or 'Final', 'Semi-final', etc.
    ##   todo: use to_s - why? why not?
    @round    = kwargs[:round]    if kwargs.has_key?( :round )
    @stage    = kwargs[:stage]    if kwargs.has_key?( :stage )
    @leg      = kwargs[:leg]      if kwargs.has_key?( :leg )
    @group    = kwargs[:group]    if kwargs.has_key?( :group )
    @status   = kwargs[:status]   if kwargs.has_key?( :status )
    @comments = kwargs[:comments] if kwargs.has_key?( :comments )

    @league   = kwargs[:league]   if kwargs.has_key?( :league )
    @ground   = kwargs[:ground]   if kwargs.has_key?( :ground )
    @timezone = kwargs[:timezone] if kwargs.has_key?( :timezone )
    @att      = kwargs[:att]      if kwargs.has_key?( :att )


    if kwargs.has_key?( :score )   ## check all-in-one score struct for convenience!!!
      score = kwargs[:score]

      if score.nil?   ## reset all score attribs to nil!!
        @score = []    ##  [nil,nil]
      else
        ## check if is array - assume "generic" score e.g. 3-2
        ##     that is, not known if full-time, after extra-time etc.
        if score.is_a?( Array )
           @score = score    ## e.g. [3,2]
        else  ## assume hash
           @score = score 
           # @score1,    @score2    =    score[:ft]  || []
           # @score1i,   @score2i   =    score[:ht]  || []
           # @score1et,  @score2et  =    score[:et]  || []
           # @score1p,   @score2p   =    score[:p]   || score[:pen] || []
           # @score1agg, @score2agg =    score[:agg] || []
        end
      end
    end
      # @score[:ht]   = kwargs[:score_ht]     if kwargs.has_key?( :score_ht )
      # @score[:et]   = kwargs[:score_et]     if kwargs.has_key?( :score_et )
      # @score[:p]    = kwargs[:score_p]      if kwargs.has_key?( :score_p )
      # @score[:agg]  = kwargs[:score_agg]    if kwargs.has_key?( :score_agg )

      ## note: (always) (auto-)convert scores to integers
      # @score1     = @score1.to_i(10)      if @score1
      # @score1i    = @score1i.to_i(10)     if @score1i
      # @score1et   = @score1et.to_i(10)    if @score1et
      # @score1p    = @score1p.to_i(10)     if @score1p
      # @score1agg  = @score1agg.to_i(10)   if @score1agg

      # @score2     = @score2.to_i(10)      if @score2
      # @score2i    = @score2i.to_i(10)     if @score2i
      # @score2et   = @score2et.to_i(10)    if @score2et
      # @score2p    = @score2p.to_i(10)     if @score2p
      # @score2agg  = @score2agg.to_i(10)   if @score2agg

    ## todo/fix:
    ##  gr-greece/2014-15/G1.csv:
    ##     G1,10/05/15,Niki Volos,OFI,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
    ##

    ##  for now score1 and score2 must be present
    ## if @score1.nil? || @score2.nil?
    ##  puts "** WARN: missing scores for match:"
    ##  pp kwargs
    ##  ## exit 1
    ## end

    ## todo/fix: auto-calculate winner
    # return 1,2,0   1 => team1, 2 => team2, 0 => draw/tie
    ### calculate winner - use 1,2,0
    ##
    ##  move winner calc to score class - why? why not?
    if @score 
      if @score.is_a?( Array )
        if @score[0] > @score[1]
          @winner = 1
        elsif @score[1] > @score[0]
           @winner = 2
        elsif @score[0] == @score[1]
           @winner = 0
        end
      else  ## assume Hash
        ## to be one 
        ##   check for agg, pen, ft, etc.
        @winner = nil   # unknown / undefined
      end
    else
      @winner = nil   # unknown / undefined
    end


    self   ## note - MUST return self for chaining
  end



  def over?()      true; end  ## for now all matches are over - in the future check date!!!
  def complete?()  true; end  ## for now all scores are complete - in the future check scores; might be missing - not yet entered


 

  ####
  ##  deprecated - use score.to_s and friends - why? why not?
  # def score_str    # pretty print (full time) scores; convenience method
  #  "#{@score1}-#{@score2}"
  # end

  # def scorei_str    # pretty print (half time) scores; convenience method
  #  "#{@score1i}-#{@score2i}"
  # end


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

    data['time'] = @time  if @time
  end

  data['team1'] =  @team1.is_a?( String ) ? @team1 : @team1.name
  data['team2'] =  @team2.is_a?( String ) ? @team2 : @team2.name

  ## note - score might be 
  ##           1) array e.g. [0,1]
  ##           2) hash  e.g. { ft: [0,1] } etc.      
  data['score'] = if @score.is_a?(Hash)
                     # note: make sure hash keys are always strings
                     @score.transform_keys(&:to_s)
                  elsif @score.is_a?(Array)
                     ## note: 
                     ##   for now always assume full-time (ft)
                     ##     in future check for score note or such
                     ##      to  use "plain" array or such - why? why not?   
                     { 'ft' => @score }
                  else  ## assume nil   
                     {}
                  end

                  
  ## data['score']['ht'] = [@score1i,   @score2i]     if @score1i && @score2i
  ## data['score']['ft'] = [@score1,    @score2]      if @score1 && @score2
  ## data['score']['et'] = [@score1et,  @score2et]    if @score1et && @score2et
  ## data['score']['p']  = [@score1p,   @score2p]     if @score1p && @score2p



  ### check for goals
  if @goals && @goals.size > 0
    data['goals1'] = []
    data['goals2'] = []

    @goals.each do |goal|
          node = {}
          node['name']    = goal.player
          node['minute']  = goal.minute
          node['offset']  = goal.offset  if goal.offset
          node['owngoal'] = true         if goal.owngoal
          node['penalty'] = true         if goal.penalty
          
          if goal.team == 1
            data['goals1']  << node   
          else  ## assume 2
            data['goals2']  << node
          end
     end  # each goal
  end


  data['status'] = @status  if @status

  data['group']  = @group   if @group
  data['stage']  = @stage   if @stage

  if @ground
       ## note: might be array of string e.g. ['Wembley', 'London']
       ## data['ground'] = {}
       ## data['ground']['name']      = @ground
       ## data['ground']['timezone']  = @timezone   if @timezone

       ## note - keep timezone for now out of ground!!
       ##  todo/check - auto-join to string - why? why not?
       ##                   e.g.  ['Wembley', 'London']
       ##                     to   'Wembley, London'
       ##   note - auto-join geo tree for now
       data['ground'] = @ground.join(', ')
  end
  
  data['attendance'] = @att   if @att    
  data
end


end  # class Match
end # module Sports


