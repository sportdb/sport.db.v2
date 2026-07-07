module Fbtxt
class Lexer



def self._build_goal_minute( m )
    minute = {}

    minute[:m]     =  m[:value].to_i(10)   ## always required

    ## stoppage/injury time (offset)
    minute[:offset] = m[:value2].to_i(10)   if m[:value2]

    minute[:og]  = true       if m[:og]
    minute[:pen] = true       if m[:pen]
    minute[:freekick] = true  if m[:fk]
    minute[:header] = true    if m[:hdr]

    minute[:secs] = m[:secs].to_i(10)   if m[:secs]

    minute
end

def self._build_goal_minute_na( m )
    minute = {}

    minute[:m]     =  '?'   ##  or use nil or 999 or -1 or ???

    minute[:og]  = true       if m[:og]
    minute[:pen] = true       if m[:pen]
    minute[:freekick] = true  if m[:fk]
    minute[:header] = true    if m[:hdr]

    minute
end



def self._build_minute( m )
    minute = {}
    minute[:m]      = m[:value].to_i(10)   ## always required

    ## stoppage/injury time (offset)
    minute[:offset] = m[:value2].to_i(10)   if m[:value2]

    minute
end


def self._build_goal_count( m )
    count = {}
    count[:count] = m[:value].to_i(10)        if m[:value]
    count[:og]    = m[:og_value] ? m[:og_value].to_i(10) : 1      if m[:og]   ## check flag
    count[:pen]   = m[:pen_value] ? m[:pen_value].to_i(10) : 1    if m[:pen]  ## check flag
    count
end

def self._build_goal_type( m )
    goal = {}
    goal[:og]       = true  if m[:og]
    goal[:pen]      = true  if m[:pen]
    goal[:freekick] = true  if m[:fk]
    goal[:header]   = true  if m[:hdr]
    goal
end


def _build_goal_minute( m ) self.class._build_goal_minute( m ); end
def _build_goal_minute_na( m ) self.class._build_goal_minute_na( m ); end
def _build_minute( m ) self.class._build_minute( m ); end
def _build_goal_count( m ) self.class._build_goal_count( m ); end
def _build_goal_type( m ) self.class._build_goal_type( m ); end





###
# parse helpers

def self._parse_goal_minute( str )
    ## note - strip - leading/trailing spaces
    m = GOAL_MINUTE_RE.match( str.strip )
    if m && m.pre_match == '' && m.post_match == ''
      _build_goal_minute( m )
    elsif  m
        ## note - match BUT not anchored to start and end-of-string!!!
        ##  report, error somehow??
      nil
    else
      nil  ## no match - return nil
    end
end

def self._parse_goal_count( str )
    ## note - strip - leading/trailing spaces
    m = GOAL_COUNT_RE.match( str.strip )
    if m && m.pre_match == '' && m.post_match == ''
      _build_goal_count( m )
    elsif  m
        ## note - match BUT not anchored to start and end-of-string!!!
        ##  report, error somehow??
      nil
    else
      nil  ## no match - return nil
    end
end





end   # class Lexer
end   # module Fbtxt
