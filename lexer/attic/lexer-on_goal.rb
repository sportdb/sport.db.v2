
GOAL_RE = Regexp.union(
    SPACES_RE,
    GOAL_NONE_RE,
    GOAL_MINUTE_RE,
    GOAL_MINUTE_NA_RE,
    GOAL_COUNT_RE,
    PROP_NAME_RE,    ## note - (re)use prop name for now for (player) name
    GOAL_SEP_ALT_RE,   ##  note - add dash (-) with (required) spaces
    /  (?<sym> [;,)])  /x
)



def _on_goal( m, ctx: )
  #...
  elsif m[:goals_none]    ## note - eats-up semicolon!! e.g. -; or - ;
             # was:[:GOALS_NONE,"<|GOALS_NONE|>"]
             ##   use literal text!!
             Token.new( :GOALS_NONE, m[:goals_none],
                            lineno: ctx.lineno, offset: m.offset(:goals_none))


end