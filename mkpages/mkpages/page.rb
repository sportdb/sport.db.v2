

class Page
    ## maybe later -  read meta (title) on demand only
    attr_reader :site, :relpath, :basename


    ###
    ## keep track of errors
    ##    maybe move to Page::Stat e.g.
    ##     Page:Stat#errors
    ##
    ##     incl. match_count etc
    def errors?() @errors.is_a?(Array) && @errors.size > 0;  end
    def errors=( errors ) @errors = errors; end
    def errors() @errors || []; end


    ### flattened (relative) outpath - incl.
    ###   e.g. 2024-25/1-premier  =>  2024-25_1-premier
    ###
    ###  check/rename   use calc/mk_outpath or such?
    def outpath( extension = '.html')
                         outpath = ""
                         outpath += @relpath

                         ## strip archive/YYYYs/
                         outpath = outpath.sub( %r{^archive/\d{4}s/
                                                   }ix, '' )

                         ## replace  / (slash) with _ (underscore)
                         outpath = outpath.gsub( '/', '_' )

                         outpath += "_"     unless outpath == ''
                         outpath += @basename
                         outpath += extension

                          outpath
    end


    def initialize( site:, relpath:, basename: )
        @site = site    # link to (parent) site

        @relpath  = relpath
        @basename = basename

        ## get meta data block via html-style comment header (in .txt)
        ##    incl.   title, autor(s), source,  updated
        ##  e.g.
        ##    <!--
        ##       title:   Austria 2024/25
        ##       source:  https://rsssf.org/tableso/oost2025.html
        ##       author:  Hans Schöggl
        ##       updated: 7 Jul 2025
        ##      -->
        ##  -or-
        ##      authors: Hans Schöggl and Karel Stokkermans

        ## @meta   =   parse_meta( _read_text() )
    end



    def _read_text
        txt = read_text( "#{@site.dir}/#{relpath}/#{basename}.txt" )

        ## check windows files on unix  -- remove \r - carriage return (cr)
        ##  clean-up windows-style newlines - why? why not?
        txt = txt.gsub( "\r\n", "\n" )
        txt
    end

    ## note - maybe memorize (cache) txt later - why? why not?
    ##    do NOT reread - and freeze text (to make read-only)??
    alias_method :txt,  :_read_text
    alias_method :text, :_read_text

end # class Page
