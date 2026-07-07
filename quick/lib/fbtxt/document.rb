require 'fbtxt/parser'       # depends on/pulls in: cocos

require 'season-formats'





## our own code
require_relative 'document/version'

##  match & league machinery
require_relative 'document/match_tree'
require_relative 'document/match_tree-helpers'

require_relative 'document/match_tree/match'    ## ("inline") structs
require_relative 'document/match_tree/goal'
require_relative 'document/match_tree/round'
require_relative 'document/match_tree/group'

require_relative 'document/match_tree_on/on_group_def'
require_relative 'document/match_tree_on/on_round_def'
require_relative 'document/match_tree_on/on_round_outline'
require_relative 'document/match_tree_on/on_date_header'
require_relative 'document/match_tree_on/on_match_line'
require_relative 'document/match_tree_on/on_goal_line'


require_relative 'document/quick_match_reader'



puts Fbtxt::Module::Document.banner    # say hello
