
## remove newline tokens
##   replaced by END & PROP_END


  ## puts "tokens_by_line:"
    ## pp tokens_by_line

    if flatten
      ## flatten tokens
      tokens = []
      tokens_by_line.each do |tok_line|

        ## if debug?
        ##   pp tok_line
        ## end

         tokens  += tok_line

         ## auto-add newlines  (unless BLANK!!)
         unless tok_line[0] && tok_line[0].type == :BLANK
            ## note - reuse lineno from first token in line
            ##                  use last - why? why not?
            tokens  << Token.newline( lineno: tok_line[0].lineno )
         end
      end
      [tokens,errors]
   else
      [tokens_by_line, errors]
   end
