require 'sportdb/parser'   # deps:   cocos, racc

require 'season-formats'





## our own code
require_relative 'quick/version'

##  match & league machinery
require_relative 'quick/match_tree'
require_relative 'quick/match_tree-helpers'

require_relative 'quick/match_tree/match'    ## ("inline") structs
require_relative 'quick/match_tree/goal'
require_relative 'quick/match_tree/round'
require_relative 'quick/match_tree/group'

require_relative 'quick/match_tree_on/on_group_def'
require_relative 'quick/match_tree_on/on_round_def'
require_relative 'quick/match_tree_on/on_round_outline'
require_relative 'quick/match_tree_on/on_date_header'
require_relative 'quick/match_tree_on/on_match_line'
require_relative 'quick/match_tree_on/on_goal_line'


require_relative 'quick/quick_match_reader'



puts SportDb::Module::Quick.banner    # say hello
