



HX_RE = %r{          ## negative lookahead
                     ##   do NOT match  =-=
                     ##   do NOT match  ===========  (without any heading text!!)
                     ##     e.g.
                     ##       Fall season
                     ##       ===========

                    (?! ^[ ]* (?:    =-=
                                 |  ={1,} [ ]* $
                               )
                     )

                     ^
                    ## (i) required leading markers
                             [ ]* (?<marker> ={1,6}) [ ]*
                    ## (ii) heading text  -- note: non-greedy match
                            (?<text> .+?)
                    ## (iii) optional trailing markers
                            (?: [ ]* ={1,6}  )?
                    [ ]*
            $}x




def build_page( page )

    site =  page.site   ## note - autoget site reference from page
                        ##   lets you use   site.has_page?( pageref ) or such

    txt   = page.txt

#    title = page.title
    title = '[add title here]'


#   toc = build_toc( txt, min: 2 )



   ## remove all leading spaces & newlines
   txt = txt.lstrip


   ## mark html-style comments
   ##  with span.comment
   ##   note  - remove comment markers!!
   txt = txt.gsub( %r{<!-{2,}
                          (?<text> .*? )
                        -{2,}>
                     }ixm ) do |_|
                        m = Regexp.last_match

                        "<span class='comment' title='comment block'>" +
                        "#{m[:text]}" +
                        "</span>"
                  end


   ## mark end-of-line comments
   ##   note  - keep comment markers
   txt = txt.gsub( %r{
                           (?<comment> \#{1,} [ ]*
                               .*?
                            )
                            [ ]*
                        $
                       }ix) do |_|
                          m = Regexp.last_match
                        "<span class='comment' title='end-of-line comment'>" +
                        "#{m[:comment]}" +
                        "</span>"
                       end



   ## remove newlines if more than triple
    txt = txt.gsub( /\n{3,}/, "\n\n\n" )


   ## note - assume h1 is title
   title = '[No Title]'   ## use Untitled or ?? - why? why not?

   ## replace headings (h1/h2/h3/h4/h5/h6)
   txt = txt.gsub( HX_RE ) do |_|
                m = Regexp.last_match

                level = m[:marker].size

                ## note - for level 5,6
                ##     for now do NOT print markers!!!
                if level >= 5
                    "<h#{level}>#{m[:text]}</h#{level}>"
                else
                    ## note - record title if h1 found
                     title = m[:text]   if level == 1

                    "<h#{level}>#{'='*level} #{m[:text]} #{'='*level}</h#{level}>"
               end
             end


  ## build table of contents (toc)


=begin
‹XLVIII Girabola, see §girabola›
‹Taça, see §taca›
‹Segundona, see §segundona›
‹Provincial Leagues, see §province›
=end

##
##  fix/fix//fix - must escape &



 banner = build_banner( page: page )


body = String.new
## body   += toc   if toc

## note - wrap .txt page in its own pre block
body   += "<pre>\n"
body   += txt
body   += "</pre>\n"


  ## change body to content - why? why not?
   html = build_layout( title:  title,
                        body:   body,
                        banner: banner )


   html
end
