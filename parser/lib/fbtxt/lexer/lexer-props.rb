module Fbtxt
class Lexer

  ##  note - separate sent off and red card
  ##     sent-off - incl. red card, yellow/red card and the era before red cards!!

  ## add (back) goals PROPS too
  #   elsif ['goals'].include?( key.downcase )
  #     @re = PROP_GOAL_RE
  #     tokens << [:PROP_GOALS, m[:key]]


  ##     i) token symbol
  ##    ii) lexer (regex) mode
  ##   iii) downcase (alt) names

  ##
  ## (well-known) props
  ##  note - will NOT incl. lineup with "custom" team names
  PROP_SPECS = [
       [:PROP_YELLOWCARDS, PROP_CARDS_RE, ['yellow',
                                           'yellow cards']],

        ## todo: check allow yellow/red cards: or such as key!!!
        ##   check for alternate spellings
        ##   'yellow/red cards' - note - meaning closes to yellow or red !!
        ##    thus use yellow-red cards as default/standard - why? why not?
       [:PROP_YELLOWREDCARDS, PROP_CARDS_RE, ['yellow-red',
                                              'yellow-red cards',
                                              'yellowred cards']],
       [:PROP_REDCARDS,    PROP_CARDS_RE, ['red',
                                           'red cards']],
        [:PROP_SENTOFF,     PROP_CARDS_RE, ['sent-off',
                                           'sent off']],

        ## note - allow/support assistant refs
       [:PROP_REFEREE,   PROP_REFEREE_RE,  ['ref', 'referee',
                                            'refs', 'referees']],
       [:PROP_ATTENDANCE, PROP_ATTENDANCE_RE, ['att', 'attn', 'attendance']],
       [:PROP_PENALTIES,  PROP_PENALTIES_RE, ['penalties',
                                              'penalty shootout',  'shootout',
                                              'penalty shoot-out',  'shoot-out',
                                              'penalty kicks']],

       [:PROP_COACH,   PROP_COACH_RE,  ['coach', 'trainer',
                                        'coaches', 'trainers']],

]

  ## map alternate prop names to prop spec record
  ##   note - double check - (auto-)downcase, strip spaces - why? why not?
  ##   rename to (shorter) PROP_KEYS - why? why not?
  KNOWN_PROP_KEYS = begin
      h = {}
      PROP_SPECS.each do |spec|
          token,mode,names = spec
          names.each do |name|
              h[ name.strip.downcase ] = spec
          end
      end
      h
  end


end  # class Lexer
end # module Fbtxt
