
module Fbtxt
class MatchTree


=begin
## fix-fix-fix
##    move into (nested inside) Lineup - why? why not?
class Card
  attr_reader :name, :minute
  def initialize( name:, minute: nil )
    @name   = name
    @minute = minute
  end
end  ## class Card
=end




    ## note - lineup incl. starter & (optional) bench
class Lineup

    attr_accessor :bookings
    def initialize
        @starter = {}    ## note - indexed by (player) name
        @bench   = {}    ## note - indexed by (player) name
        @subs    = []
    end

    def starter()  @starter.values; end
    def bench()    @bnech.values; end
    def subs()     @subs; end


    def find_player( name )
        player = @starter[name] || @bench[name]
    end






    def add_lineup( lineup )
        ## add starter & bench (via substitutions)
        _add_starter( lineup )
        _add_bench( lineup )
        _add_subs( lineup )
    end

    def _add_starter( lineup )
      lineup.each do |item|
 ##        puts " lineup.each item:"
 ##        pp item
           rec = Player.new( name:    item.name,
                             captain: item.captain )

          @starter[item.name] = rec
      end
    end

    def _add_bench( lineup )
      lineup.each do |item|
           current = item
           while current && current.sub
              rec = Player.new( name:    current.sub.sub.name,
                                captain: current.sub.sub.captain )

               @bench[current.sub.sub.name] = rec
               current = current.sub.sub
           end
      end
    end




   def _add_subs( lineup )
      recs = []
      lineup.each do |item|
           current = item
           while current && current.sub
              ##  fix-fix-fix - use player-ref for off/on
              rec =  EventSub.new( off:  current.name,
                                    on:   current.sub.sub.name,
                                    minute: current.sub.minute )
              recs << rec
              current = current.sub.sub
           end
      end


   ## note - (auto-)sort by minute if present
   @subs = recs.sort do |l,r|
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
    end


    def as_json(*)

      ### note - as_json EXCLUDES bookings !!!

        h = { 'starter' => @starter.values.as_json }

        h['bench'] = @bench.values.as_json    if @bench.size > 0
        h['subs']  = @subs.as_json            if @subs.size > 0

        h
    end




#######################
## move to shared helper - why? why not?

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
end  # class Lineup




end # class MatchTree
end # module Fbtxt