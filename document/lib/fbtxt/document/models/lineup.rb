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




## note - lineup incl. starter & (optional) bench & sub(stituion)s
class Lineup



    def self.build( lineup )
        ## add starter & bench (via substitutions)
       starter = _collect_starter( lineup )
       bench   = _collect_bench( lineup )
       subs    = _collect_subs( lineup )

       new( starter: starter,
            bench: bench,
            subs: subs )
    end


    def self._collect_starter( lineup )
      recs = []
      lineup.each do |item|
 ##        puts " lineup.each item:"
 ##        pp item
           rec = Player.new( name:    item.name,
                             captain: item.captain )

           recs << rec
      end
      recs
    end

    def self._collect_bench( lineup )
      recs = []
      lineup.each do |item|
           current = item
           while current && current.sub
              rec = Player.new( name:    current.sub.sub.name,
                                captain: current.sub.sub.captain )

               recs << rec
               current = current.sub.sub
           end
      end
      recs
    end

   def self._collect_subs( lineup )
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
   recs = recs.sort do |l,r|
                    if l.minute && r.minute
                        l.minute <=> r.minute
                    else
                       0  ## keep as is (no minutes available)
                    end
               end
      recs
    end




    def initialize( starter:,
                    bench: [],
                    subs:  [] )
        @starter = {}    ## note - indexed by (player) name
        starter.each do |player|
            @starter[player.name] = player
        end

        @bench   = {}    ## note - indexed by (player) name
        bench.each do |player|
             @bench[player.name] = player
        end

        @subs    = subs

        ## note - use array (supports multiple coaches)
        @coaches   = []
    end

    def starter()  @starter.values; end
    def bench()    @bnech.values; end
    def subs()     @subs; end


    def coaches()        @coaches; end
    def coaches=(value)  @coaches = value; end



    def find_player( name )
        player = @starter[name] || @bench[name]
    end



    def as_json(*)
        h = { 'starter' => @starter.values.as_json }

        h['bench'] = @bench.values.as_json    if @bench.size > 0
        h['subs']  = @subs.as_json            if @subs.size > 0

        ## note - use coach (singular) for now even if (always) serialzed to array for now
        h['coach'] = @coaches.as_json           if @coaches.size > 0

        h
    end
end  # class Lineup


end # module Model
end # module Fbtxt