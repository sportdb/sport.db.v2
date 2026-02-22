#############
##  note - the SCORE_NOTE format is experimental  (and work-in-progress)
##                  and, thus, may change in the future
##                   and get moved to its own parser (or level 3) or such

module SportDb
class Lexer

##   score with note  e.g.
##     2-3  [aet]
##     2-2  [aet, 5-2 on penalties]  etc.
##
##   note - only "simple" score e.g. 1-4 or 3-3 can be followed by score note!
##               e.g.  1-4 aet [Ajay wins 5-2 on penalties] NOT allowed!!


SCORE_NOTE_RE = %r{
   (?<score_note>
     ##### e.g. 2-1
        \b
          (?<score1>\d{1,2}) - (?<score2>\d{1,2})
            [ ]+
   \[
    (?:
      ##############
      # plain aet e.g. [aet]
      (?:    aet | a\.e\.t\. |
             after [ ] extra [ -] time
       )
      |
       #########################
       ## plain penalties e.g. [3-2 pen] 
       (?:  
             \d{1,2}-\d{1,2}
                [ ]* (?: p|pen )
       )
      |
        ####################
        ## plain aet with penalties e.g. [aet; 4-3 pen] or [aet, 4-3p]
        (?:  
              aet [ ]* [,;]      ##  allow semi-colon - why? why not?
                [ ]*
              \d{1,2}-\d{1,2}
                [ ]* (?: p|pen )
         )
      |
         ##############################
         ## e.g. Spain wins on penalties
         ##       1860 München wins on penalties etc.
         ##   must start with digit 1-9 or letter
         ##     todo - add more special chars - why? why not?
         ##     
         (?:
               (?:
                    aet [ ]*   ## allow space here - why? why not
                       [,;][ ]
                )?
           
              (?:
               ###########
               # opt 1 - no team listed/named - requires score
              (?: 
                 (?: won|wins? ) [ ]     ## note - allow won,win or wins
                (?:   ## score
                   \d{1,2}-\d{1,2}
                   [ ]
                ) 
                on [ ]  (?: pens | penalties |
                          aggregate  )   
               )
              |
                ##########################
                # opt 2 - team required; score optional
              (?:  
                (?:  ## team required
                      [1-9\p{L}][0-9\p{L} .-]+?    
                     [ ]
                 )
                 (?: won|wins? ) [ ]     ## won/win/wins
                 (?:   ## score optional
                    \d{1,2}-\d{1,2}
                    [ ]
                  )?            
                  on [ ] (?:  pens | penalties |
                              aggregate  )
                ###  [^\]]*?   ## allow more? use non-greedy
          )
        ))
         |
         ##########
         ##   e.g. agg 3-2 etc.
         (?:  
             agg [ ] \d{1,2}-\d{1,2}
         )
         |
         ############
         ##    e.g. agg 4-4, Ajax win on away goals
         (?:   
              (?:   ## agg 4-4, optional for now - why? why not? 
                 agg [ ] \d{1,2}-\d{1,2} 
                 [ ]*[,;][ ]
               )?
             (?:  ## team required
                      [1-9\p{L}][0-9\p{L} .-]+?    
                     [ ]
              )
              (?: won|wins? ) [ ]     # won/win/wins
              on [ ] away [ ] goals
         )
       )
    \]
   )   # score_note ref
}ix

end  #  class Lexer
end  # module SportDb

