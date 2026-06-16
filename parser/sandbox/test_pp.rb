####
#  to run use:
#    $ ruby sandbox/test_pp.rb

$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'

Minute = RaccMatchParser::Minute
Lineup = RaccMatchParser::Lineup
Card   = RaccMatchParser::Card
Sub    = RaccMatchParser::Sub


sub = Sub.new( sub: Lineup.new( name: 'Player' ),  minute: Minute.new( m: 11 ) )
pp sub

sub = Sub.new( sub: Lineup.new( name: 'Player',
                                captain: true,
                                cards: [Card.new( name: 'Y', minute: Minute.new( m: 8 ))]),
               minute: Minute.new( m: 11 ) )
pp sub

sub = Sub.new( sub: Lineup.new( name: 'Player',
                                cards: [Card.new( name: 'Y', minute: Minute.new( m: 8 )),
                                        Card.new( name: 'R')]),
               minute: Minute.new( m: 11 ) )
pp sub



lineup = Lineup.new( name: 'Player A',
                     cards: [Card.new( name: 'Y')],
                     sub: Sub.new( sub: Lineup.new(
                                                  name: 'Player B',
                                                  cards: [Card.new( name: 'Y', minute: Minute.new( m: 28 ))]),
                                    minute: Minute.new( m: 11 ) ))

pp lineup

puts "bye"
