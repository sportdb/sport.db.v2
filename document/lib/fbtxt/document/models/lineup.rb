=begin

(double) check bookings
  -  is trainer or co-trainer - why NOT included in lineup ???
==> reading >austria/2025-26/1-bundesliga-full.txt<...
!! warn - player >Thomas Turner< NOT found; skipping booking Thomas Turner 90+3
!! warn - player >Thomas Turner< NOT found; skipping booking Thomas Turner 88
!! warn - player >Tobias Schützenauer< NOT found; skipping booking Tobias Schützenauer 90+5
!! warn - player >Jeyland MITCHELL< NOT found; skipping booking Jeyland MITCHELL 77
!! warn - player >Lukas Gütlbauer< NOT found; skipping booking Lukas Gütlbauer 84
=end



module Fbtxt
  module Model

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
   ###  fix-fix-fix  move sort to EventSub  <=>  - why? why not?
   @subs = recs.sort do |l,r|
                    if l.minute && r.minute
                        l.minute <=> r.minute
                    else
                       0  ## keep as is (no minutes available)
                    end
               end
    end


    def as_json(*)
        h = { 'starter' => @starter.values.as_json }

        h['bench'] = @bench.values.as_json    if @bench.size > 0
        h['subs']  = @subs.as_json            if @subs.size > 0

        h
    end
end  # class Lineup


end # module Model
end # module Fbtxt