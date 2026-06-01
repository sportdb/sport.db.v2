
##
## check for "literal"  (multi-line) note blocks
##   eg.  nb:  or note:
##   space required after double colon - why? why not?
PREPROC_NOTA_BENE_RE = %r{
         ^
    [ ]* (?: nb | note) [ ]* : [ ]+
       .+?  ## non-greedy

    ## positive lookahead
    ##    note - must end with blank line or end-of-file/document
    ##    note - do NOT eat-up trailing hrule (---)
    ##
    ##   todo/check - check/revisit again for hrule case/excepion sample
    ##      add here  or remove - why? why not?
      (?=      (?: \n [ ]* -{3,} [ ]*)?
                   \n[ ]*\n
                 | \z
        )
}xim
