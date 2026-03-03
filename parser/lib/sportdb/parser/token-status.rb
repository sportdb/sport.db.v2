module SportDb
class Lexer
  
##  (match) status
##    note: english usage - cancelled (in UK), canceled (in US)
##
##  add more variants - why? why not?


POSTPONED = %Q{ (?<postponed> postponed  | postp\\.?  | ppd\\.? ) }
CANCELED  = %Q{ (?<canceled>  cancell?ed | canc\\.? ) }    ##  add can/can. - why? why not?
WALKOVER  = %Q{ (?<walkover>  walkover   | w/o  | wo ) }   ## add o/w too - why? why not?                
AWARDED   = %Q{ (?<awarded>   awarded    | awd\\.? ) }                     
SUSPENDED = %Q{ (?<suspended> suspended  | susp\\.? ) }                     
ABANDONED = %Q{ (?<abandoned> abandoned  | aban\\.?  | abd\\.? ) }
ANNULLED  = %Q{ (?<annulled>  annulled ) } 
VOIDED    = %Q{ (?<voided>    voided     | void ) }  ### note - alternative (name) to annulled                    

REPLAY    = %Q{ (?<replay>    replay     | repl\\.? ) }  



STATUS_RE = %r{
            \[
      (?:    
#############################################  
### opt 1 - allow long forms with note/comment for some stati
##                    e.g. [postponed due to tropical storm "Hanna"]
##                         [suspended at 84' by storm; result stood]
#########################
           (?: (?<status> 
               ####################
               ## pre-match (not played)
                    #{POSTPONED}
                           |
                    #{CANCELED}       
                           |
                    #{WALKOVER}        
                           |
               ######################   
               ## pre/post match
                     #{AWARDED}
                            |
               ########################
               ## post match - (partially) played
                    #{SUSPENDED} 
                            |   
                    #{ABANDONED}
                            |
                    #{ANNULLED}
                            |
                    #{VOIDED} ### note - alternative to annulled
              ) 
              [ ;,-]+  ## eat-up leading spaces (or separators) 
               (?<status_note> 
                    [^\]]+?   ## note - add non-greedy match 
                 )   
              [ ]*  ## eat-up trailing spaces
            )
            |       
########################################
## opt 2 - short form only (no note/comments) e.g. [postponed], [Canceled], etc.
####################################     
            (?<status>
         ####################
         ## pre-match (not played)
               #{POSTPONED}
                 |
               #{CANCELED}
                 |
               #{WALKOVER}         
                 |
         ######################   
         ## pre/post match
               #{AWARDED}
                 |
         ########################
         ## post match - (partially) played
               #{SUSPENDED}                                        
                 |
               #{ABANDONED}
                 |
               #{ANNULLED}
                 |
               #{VOIDED}   ### note - alternative to annulled
                 |
               #{REPLAY}       ### todo/fix - keep replay - why? why not?
                                  ###   prefer replay in round e.g. 
                                  ##       ▪ Round 17, Replay
                                  ##       ▪ Semi-finals, Replays
            )
      )
    \]
}ix


def self._build_status( m )
        status = {}
        ## note - norm status text - why? why not?
        status[:status] = if    m[:postponed] then 'postponed'
                          elsif m[:canceled]  then 'canceled'
                          elsif m[:walkover]  then 'walkover'
                          elsif m[:awarded]   then 'awarded'
                          elsif m[:suspended] then 'suspended'
                          elsif m[:abandoned] then 'abandoned'
                          elsif m[:annulled] ||
                                m[:voided]    then 'annulled'
                          elsif m[:replay]    then 'replay'      
                          else  ## fallback on "generic" status (shouldn't happen)
                            m[:status]
                          end

        ## includes note? e.g.  awarded; originally 2-0
        status[:status_note] = m[:status_note]   if m[:status_note]   
         
        status
end  
def _build_status( m ) self.class._build_status( m ); end


end  #  class Lexer
end  # module SportDb


__END__




####################
## pre-match (not played)
postponed|postp\.|ppd\.
             ## e.g. [postponed due to problems with the screen of the stadium]
             ##      [postponed by storm]
             ##      [postponed due to tropical storm "Hanna"]
             ##      [postponed from Sep 10-12 due to death Queen Elizabeth II]

cancell?ed|canc.\       
 
walkover|w/o|wo       
## A victory awarded to one team because the opponent was unable 
##  or unwilling to compete (e.g., failing to show up or being disqualified).
##  -or-
##  A walkover or "win over" reveals when a team has won a game
##    without it being played. 
##  -or-
##  see <https://en.wikipedia.org/wiki/Walkover>



######################   
## pre/post match
awarded|awd\.

            ## e.g. [awarded match to Leones Negros by undue alignment; original result 1-2]
             ##     [awarded 3-0 to Cafetaleros by undue alignment; originally ended 2-0]
             ##     [awarded 3-0; originally 0-2, América used ineligible player (Federico Viñas)]
 
## A result that is decided by a governing body 
##  (like FIFA or a domestic league) rather than by the play on the pitch.
## Usually follows a Forfeit or Walkover. 
## If a team refuses to play, abandons a match, or fields an ineligible player, 
##  the opponent is typically awarded a 3-0 victory.

########################
## post match - (partially) played
suspended|susp\.        

            ## e.g. [suspended at 0-0 in 12' due to storm]  
             ##      [suspended at 84' by storm; result stood]
 
## The match is temporarily halted but intended to be resumed or restarted later.

abandoned|aban.\|abd\.

             ## e.g. [abandoned at 1-1 in 65' due to cardiac arrest 
             ##          Luton player Tom Lockyer]
             ##      [abandoned at 0-0 in 6' due to waterlogged pitch]
             ##     [abandoned at 5-0 in 80' due to attack 
             ##          on assistant referee by Cerro; result stood]
             ##    [abandoned at 1-0 in 31']
             ##    [abandoned at 0-1' in 85 due to crowd trouble]

## The match started but was stopped by the referee before the final whistle 
##  (e.g., due to a waterlogged pitch or player injury) and did not resume

annulled  OR  voided|void
## The match result is struck from the record entirely,
##  usually due to a team's withdrawal from the league or a severe rule violation.

  