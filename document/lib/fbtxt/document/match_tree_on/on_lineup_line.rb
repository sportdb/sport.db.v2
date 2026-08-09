module Fbtxt
class MatchTree



 MINUTE_RE = %r{  \A
                       (?<minute>\d{1,3}) '?
                        (  \+
                          (?<offset>\d{1,2}) '?
                        )?
                   \z
                 }x


def _parse_minute( str )

    ## support weirdo  120'+-30'  -- remove minuts
    str = str.gsub( '-', '' )

    m = MINUTE_RE.match( str )
    raise ArgumentError, "unknown goal minute format in #{str.inspect}"  if m.nil?

    minute = m[:minute].to_i(10)
    offset = m[:offset] ? m[:offset].to_i(10) : nil

    [minute,offset]
end






   def _collect_subs( lineup )
      recs = []

      lineup.each do |item|
           if item.sub
              recs << EventSub.new( off:  item.name,
                                    on:   item.sub.sub.name,
                                    minute: item.sub.minute )
               ## note - for now only check one recursive level "by hand"
               if item.sub.sub.sub
                  recs << EventSub.new( off: item.sub.sub.name,
                                        on:  item.sub.sub.sub.sub.name,
                                        minute: item.sub.sub.sub.minute )
               end
               ## todo/fix
               ##  add check here and warn
               ##   if another sub present (sub of sub)!!!
           end
      end

## note - (auto-)sort by minute if present
   recs = recs.sort do |l,r|
                    if l.minute && r.minute
                            ## note - minute is obj!! (Parser::Minute!!)
                            l_min,l_offset = _parse_minute( l.minute.to_s )
                            r_min,r_offset = _parse_minute( r.minute.to_s )

                            res = l_min <=> r_min
                            res = (l_offset||0) <=> (r_offset||0)   if res == 0
                            res
                    else
                       ## keep as is (no minutes available)
                       0
                    end
               end

      recs
    end


   def _collect_bench( lineup )
      recs = []

      lineup.each do |item|
           if item.sub
              recs << Player.new( name:    item.sub.sub.name,
                                  captain: item.sub.sub.captain )
               ## note - for now only check one recursive level "by hand"
               if item.sub.sub.sub
                  recs << Player.new( name:    item.sub.sub.sub.sub.name,
                                       captain: item.sub.sub.sub.sub.captain )
               end
           end
      end
      recs
   end

   def _collect_lineup( lineup )
    recs = []
    lineup.each do |item|
 ##       puts " lineup.each item:"
 ##       pp item
        recs << Player.new( name:    item.name,
                            captain: item.captain )
    end
    recs
   end


  def on_lineup_line( node )
    _trace( "on lineup: >#{node}<" )

    ## get last match
    match = @matches[-1]

    ## collect players
    team_name = node.team
    lineup    = node.lineup

    ## note -
    ##  lineup - uses nested array format
    ##    for formation
    ##
    ##  quick & dirty hack - flatten for now
    ##    refine later
    lineup = lineup.flatten

##  LineupLine = Struct.new( :team, :lineup, :formation, :coach ) do
##  Lineup     = Struct.new( :name, :captain, :cards, :sub ) do
##   Sub        = Struct.new( :minute, :sub )  do

    ## todo/check if team name match
    ##  warn if no match

    match.lineup ||= []
    match.lineup << _collect_lineup( lineup )

    match.bench ||=[]
    match.bench << _collect_bench( lineup )

    match.subs ||=[]
    match.subs << _collect_subs( lineup )
  end


end ## class MatchTree
end ##  module Fbtxt
