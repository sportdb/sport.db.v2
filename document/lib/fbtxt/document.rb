require 'fbtxt/parser'       # depends on/pulls in: cocos

require 'season-formats'





## our own code
require_relative 'document/version'

###########
## ("inline") structs
require_relative 'document/models/match'
require_relative 'document/models/goal'
require_relative 'document/models/round'
require_relative 'document/models/group'
require_relative 'document/models/player'
require_relative 'document/models/lineup'
require_relative 'document/models/penalty'
require_relative 'document/models/event'    ##  cards, sub(stitutio)s
require_relative 'document/models/minute'

###
#  add Models alias for Model
##  e.g. include Models  (instead of include Model) -- keep - why? why not?
module Fbtxt
   Models = Model
end


##  match & league machinery
require_relative 'document/match_tree'
require_relative 'document/match_tree-helpers'

require_relative 'document/match_tree_on/on_group_def'
require_relative 'document/match_tree_on/on_round_def'
require_relative 'document/match_tree_on/on_round_outline'
require_relative 'document/match_tree_on/on_date_header'
require_relative 'document/match_tree_on/on_match_line'
require_relative 'document/match_tree_on/on_match_bye'
require_relative 'document/match_tree_on/on_goal_line'
require_relative 'document/match_tree_on/on_penalties'
require_relative 'document/match_tree_on/on_lineup_line'
require_relative 'document/match_tree_on/on_cards_line'
require_relative 'document/match_tree_on/on_referee_line'


require_relative 'document/quick_match_reader'



require_relative 'document/export_utils'   ## e.g. (batch) genjson (via config)


puts Fbtxt::Module::Document.banner    # say hello
