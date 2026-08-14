module Fbtxt
class Lexer


######
## auto-fix checks line-by-line

def _prep_line( line )

       ##
       ##  first check for tabs
       ##    add error/warn
       ##    for auto-fix - replace tabs with two spaces

        line = line.gsub( "\t" ) do |_|
                  ## report error here
                  ## todo/add error here
                  _warn( "auto-fix; replacing tab (\\t) with two spaces in line #{line.inspect}" )
                   '  '   ## replace with two spaces
                 end


        ## U+00A0 (160)  -- non-breaking space (unicode)
        line = line.gsub( "\u00A0" ) do |uni|
                  ## report error here
                  ## todo/add error here
                  _warn( "auto-fix; replacing non-breaking unicode space (#{uni}/#{uni.ord}) w/ ascii space ( /#{" ".ord}) in line #{line.inspect}" )
                   ' '   ## replace with space
                 end

        ###
        ## todo/fix - print unicode numbers for [–−]
        ##                different candidates to differentiate and document!!!
        ##   – => U+2013 (8211)     -- En Dash     (unicode)
        ##   − => U+2212 (8722)     -- Minus Sign  (unicode)
        line = line.gsub( /[–−]/ ) do |uni|
                  ## report error here
                  ## todo/add error here
                  _warn( "auto-fix; replacing unicode dash (#{uni}/#{uni.ord}) w/ ascii dash (-/#{"-".ord}) in line #{line.inspect}" )
                   '-'   ## replace with ascii dash (-)
                  end

        ####   add more unsmart quotes
        ## smart quotes
        line = line.gsub( /[‘’]/ ) do |uni|
                  ## report error here
                  ## todo/add error here
                  _warn( "auto-fix; replacing unicode (smart) quote (#{uni}/#{uni.ord}) w/ ascii quote ('/#{"'".ord}) in line #{line.inspect}" )
                   "'"
                  end

        line = line.gsub( /[“”]/ ) do |uni|
                  ## report error here
                  ## todo/add error here
                  _warn( %Q{auto-fix; replacing unicode (smart) double quote (#{uni}/#{uni.ord}) w/ ascii double quote ("/#{'"'.ord}) in line #{line.inspect}} )
                   '"'
                  end

   line
end

end  # class Lexer
end  # module Fbtxt
