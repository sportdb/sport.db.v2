module SportDb
class Lexer



HTML_COMMENT_RE = %r{  <!--
                            .*?   ## note - use non-greedy/lazy *? match
                         -->
                       }xm      ## note - turn on multi-line (newline) match (for dot (.))


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
      (?=          \n[ ]*\n
                 | \z
        )
}xim



##
##  note - [] block may NOT incl. square brackets
##       what about comments (e.g. #)?
##    todo/check - rename to NOTE_BLOCK or TEXT_BLOCK or ???
PREPROC_BLOCK_RE = %r{  \[
                      [^\[\]\#]*?  ## note - use non-greedy/lazy *? match
                  \]
}xm  ## note - turn on multi-line match (for dot(.))







def _prep_doc( txt )
    ##  preprocess automagically
    ##   strip html comments
    ##      keep empty lines?            - yes  (turn in BLANK tokens)
    ##      keep leading spaces (indent) - yes  (maybe used later in upstream parser!!)
    ##
    ##  note - KEEP empty lines (get turned into BLANK token!!!!)


    ### normalize unicode (decomposed chars to composed chars)
    ##
    ##  note:  é is decomposed (in two chars e.g.)
    ##   e (101)
    ##   ́  (769)
    ##   vs
    ##     é (233)
    txt = txt.unicode_normalize(:nfc)


    ##  "universal" newlines
    ##      replace all windows-style  cr+lf (\r\n) to lf (\n) only
    txt = txt.gsub( "\r\n", "\n" )



    ###
    ## quick hack for now
    ##   remove  html-style comments <!-- -->
    ##           (incl. multi-line)  with two spaces
    ##       will mess-up lineno tracking!!!
    ##    fix later to have function lineno & colno!!!
    ##
    ##  todo/fix - why? why not?
    ##   to keep lineno intact
    ##     replace with  space and newline

    ###
    ## add more "native" multi-line comment-styles
    ##  e.g.    #[[ ... ]]  or  #<<< .. >>> or #<< .. >>
    ##                 or such - why? why not?

    txt = txt.gsub( HTML_COMMENT_RE ) do |m|
                     _trace('preproc html comment:', m )
                        '  '
                   end



   txt = txt.gsub( PREPROC_NOTA_BENE_RE ) do |m|
       if m.include?( "\n" )   ## check for newlines (\n) and replace
            _trace('preproc (multi-line) note/nota bene block:', m )
           m.gsub( "\n", '↵' )
       else
         m
       end
    end


    #####
    ## (another) quick hack for now
    ##   turn multi-line note blocks into
    ##             single-line note blocks
    ##             by changing newline (\n) to ⏎ (unicode U+23CE)
    ##              or why not  to ___ ?
    ##
    ##  unicode options for return/arrows:
    ##   -  ↵ (U+21B5): Downwards Arrow With Corner Leftwards.
    ##                This is the most common "carriage return" symbol.
    ##   -  ⏎ (U+23CE): Return Symbol.
    ##               Specifically designated as the keyboard's "Return" key symbol,
    ##                often used in user interfaces.

    txt = txt.gsub( PREPROC_BLOCK_RE ) do |m|
       if m.include?( "\n" )   ## check for newlines (\n) and replace
         _trace( 'preproc (multi-line) block:', m )
         m.gsub( "\n", '↵' )
       else
         m
       end
    end


    txt
end

end  # class Lexer
end  # module SportDb
