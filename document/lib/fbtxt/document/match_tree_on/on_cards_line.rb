module Fbtxt
class MatchTree

  def on_cards_line( node )
    _trace( "on cards: >#{node}<" )

    ## get last match
    match = @matches[-1]


    ################################
    ##  CardsLine = Struct.new( :type, :bookings )
    ##  Booking   = Struct.new( :name, :minute )


    ## check if match has lineup ??
    if match.lineup
        ## type = node.type   ## e.g. 'Y', 'Y/R', 'R', 'SENTOFF', etc.

        ## note - flatten for now
        ##   fix-fix-fix  use lineup[0], lineup[1] latter - why? why not?
        bookings = node.bookings.flatten


        bookings.each do |b|
          ##  find player ref in match lineup (team1/team2)
          player = nil
          ## note - expapand lineup[] to one or two items
          [*match.lineup].each_with_index do |lineup,i|
             player = lineup.find_player( b.name )
             next if player.nil?

             ## fix-fix-fix-  keep player obj/ref - why? why not?
             rec =  EventCard.new(
                                    type:   node.type,
                                    name:   b.name,
                                    minute: b.minute )

             match.bookings ||= [[],[]]
             match.bookings[i]  << rec

             break
          end

          if player.nil?
            ## raise ArgumentError,
            ##       "player >#{b.name}< NOT found in match (lineup): #{match.pretty_inspect}"

            ### log warn for now
            ##    might be trainer, staff or missing player from bench w/o sub
            ## fix-fix-fix
            ##    log error!!
            msg = "!! WARN - player >#{b.name}< NOT found; skipping booking #{b.pretty_inspect}"
            puts msg
            log( msg )
          end

        end
    else
      ### warn -  "standalone"  bookings for now not yet supported!!!
    end

  end

end ## class MatchTree
end ##  module Fbtxt
