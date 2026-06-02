module SportDb
class Lexer


def self._build_score( m )
            score = {}
             ##  note - score is "generic"
            ##      might be full-time (ft) or
            ##         after extra-time (aet) or such
            ##         or even undecided/unknown
            ##    thus, use score1/score2 and NOT ft1/ft2
            ##      thus, use array e.g. [1,2]
            ##           and NOT hash (table) e.g. { ft: [1,2] } !!!

            score[:score] = [m[:score1].to_i(10),
                             m[:score2].to_i(10)]

           score
end

def self._build_score_awd( m )    # score awarded (awd/awd.)
            score = {}
            ### note - use "generic" score for now
            ##         to match  A 3-0 B [awarded] etc.
            score[:score] = [m[:score1].to_i(10),
                             m[:score2].to_i(10)]
            ## add score[:awarded] = true ???
            ##  note - for now uses its own token e.g SCORE_AWD
            score
end

def self._build_score_abd( m )      # score abandonded (abd/abd.)
            score = {}
            ### note - use "generic" score for now
            score[:score] = [m[:score1].to_i(10),
                             m[:score2].to_i(10)]
            ## add score[:abd] = true ???
            ##  note - for now uses its own token e.g SCORE_ABD
            score
end

def self._build_score_full( m )
              score = {}
              score[:p] = [m[:p1].to_i(10),
                           m[:p2].to_i(10)]  if m[:p1] && m[:p2]
              score[:et] = [m[:et1].to_i(10),
                            m[:et2].to_i(10)]  if m[:et1] && m[:et2]
              score[:ft] = [m[:ft1].to_i(10),
                            m[:ft2].to_i(10)]  if m[:ft1] && m[:ft2]
              score[:ht] = [m[:ht1].to_i(10),
                            m[:ht2].to_i(10)]  if m[:ht1] && m[:ht2]

              ## add golden/silver flags
              score[:golden] = true   if m[:aetgg]  ## golden goal (gg)/sudden death (sd)
              score[:silver] = true   if m[:aetsg]  ## silver goal (sg)

              score
end

def self._build_score_fuller( m )
              score = {}
              score[:p] = [m[:p1].to_i(10),
                           m[:p2].to_i(10)]  if m[:p1] && m[:p2]
              score[:et] = [m[:et1].to_i(10),
                            m[:et2].to_i(10)]  if m[:et1] && m[:et2]
              score[:ft] = [m[:ft1].to_i(10),
                            m[:ft2].to_i(10)]  if m[:ft1] && m[:ft2]
              score[:ht] = [m[:ht1].to_i(10),
                            m[:ht2].to_i(10)]  if m[:ht1] && m[:ht2]
              score[:agg] = [m[:agg1].to_i(10),
                             m[:agg2].to_i(10)]  if m[:agg1] && m[:agg2]

              if m[:away1] && m[:away2]
                 score[:away] = [m[:away1].to_i(10),
                                 m[:away2].to_i(10)]
              elsif m[:away]    ## fallback if no away score; check away flag
                 score[:away] = true
              end

              ## add golden/silver flags
              score[:golden] = true   if m[:aetgg]  ## golden goal (gg)/sudden death (sd)
              score[:silver] = true   if m[:aetsg]  ## silver goal (sg)

              score
end


def self._build_score_fuller_more( m )
               ##    SCORE + SCORE_FULLER_MORE
               ## note -  after extra-time (aet) or full-time (ft)
               ##           score may be present in SCORE!!!
              score = {}
              score[:p] = [m[:p1].to_i(10),
                           m[:p2].to_i(10)]  if m[:p1] && m[:p2]
              score[:et] = [m[:et1].to_i(10),
                            m[:et2].to_i(10)]  if m[:et1] && m[:et2]
              score[:ft] = [m[:ft1].to_i(10),
                            m[:ft2].to_i(10)]  if m[:ft1] && m[:ft2]
              score[:ht] = [m[:ht1].to_i(10),
                            m[:ht2].to_i(10)]  if m[:ht1] && m[:ht2]
              score[:agg] = [m[:agg1].to_i(10),
                             m[:agg2].to_i(10)]  if m[:agg1] && m[:agg2]

              if m[:away1] && m[:away2]
                 score[:away] = [m[:away1].to_i(10),
                                 m[:away2].to_i(10)]
              elsif m[:away]    ## fallback if no away score; check away flag
                 score[:away] = true
              end

              ## add golden/silver flags
              score[:golden] = true   if m[:aetgg]  ## golden goal (gg)/sudden death (sd)
              score[:silver] = true   if m[:aetsg]  ## silver goal (sg)

              ## add flag in score for et/ft/ht
              ##    used for "dangling" (generic) score
              score[:score] = 'et'   if m[:aet] || m[:aetgg] || m[:aetsg]
              score[:score] = 'ft'   if m[:ft]
              score[:score] = 'ht'   if m[:ht]

              score
end


def self._build_score_legs( m )
              legs = {}

              ############
              ### build leg1 (score)
              score = {}
              score[:ft] = [m[:leg1_ft1].to_i(10),
                            m[:leg1_ft2].to_i(10)]
              legs['leg1'] = score

              ##################
              ### build leg2 (score)
              score = {}
              score[:ft] = [m[:leg2_ft1].to_i(10),
                            m[:leg2_ft2].to_i(10)]  if m[:leg2_ft1] && m[:leg2_ft2]
              score[:et] = [m[:leg2_et1].to_i(10),
                            m[:leg2_et2].to_i(10)]  if m[:leg2_et1] && m[:leg2_et2]
              score[:p]  = [m[:leg2_p1].to_i(10),
                            m[:leg2_p2].to_i(10)]  if m[:leg2_p1] && m[:leg2_p2]
              legs['leg2'] = score

              ## check for (opt) aggregate - keep on "top-level"
              legs[:agg] = [m[:agg1].to_i(10),
                            m[:agg2].to_i(10)]  if m[:agg1] && m[:agg2]
              legs[:away] = true  if m[:away]

              legs
end


def _build_score( m )             self.class._build_score( m ); end
def _build_score_awd( m )         self.class._build_score_awd( m ); end
def _build_score_abd( m )         self.class._build_score_abd( m ); end
def _build_score_full( m )        self.class._build_score_full( m ); end
def _build_score_fuller( m )      self.class._build_score_fuller( m ); end
def _build_score_fuller_more( m ) self.class._build_score_fuller_more( m ); end
def _build_score_legs( m )        self.class._build_score_legs( m ); end




###
## add parser helpers

def self._parse_score_full( str )
    ## note - strip - leading/trailing spaces automatic - why? why not?

    m = Regexp.union(
              SCORE_FULL_1ST_RE,
              SCORE_FULL_RE ).match( str.strip )

    if m && m.pre_match == '' && m.post_match == ''
       pp m
       _build_score_full( m )
    elsif  m
        ## note - match BUT not anchored to start and end-of-string!!!
        ##  report, error somehow??
      nil
    else
      nil  ## no match - return nil
    end
end



end  # class Lexer
end  # module SportDb
