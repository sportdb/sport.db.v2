

def build_index( site, outdir: )


    buf = String.new

    buf << "<pre>\n"
    buf << "#{site.pages.size} page(s):\n\n"


#############
##  fix-fix-fix
##     add errors   with details (hide/show)

    site.each_page_with_index do |page,i|

      buf << %Q{<a href="#{page.outpath('.html')}">#{page.relpath}/#{page.basename}</a>}
      buf << %Q{ <a href="#{page.outpath('.json')}">(.json)</a>}
      buf << "\n"
    end
    buf << "</pre>\n"



     outpath = "#{outdir}/index.html"

     write_text( outpath, buf )
end
