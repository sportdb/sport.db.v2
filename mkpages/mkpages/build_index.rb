

def build_index( site, outdir: )


    buf = String.new

    buf << "<pre>\n"
    buf << "#{site.pages.size} page(s):\n\n"


#############
##   check for errors   with details (hide/show)

    buferr = String.new
    site.each_page_with_index do |page,i|

      if page.errors?
         buferr << %Q{<a href="#{page.outpath('.html')}">#{page.relpath}/#{page.basename}</a>}
         buferr << " - #{page.errors.size} parse error(s):\n"
         buferr << page.errors.pretty_inspect
         buferr << "\n"
      end
    end

    if !buferr.empty?
      buf << "!! football.txt format errors found\n\n"
      buf << buferr
      buf << "\n\n"
    end


    site.each_page_with_index do |page,i|
      buf << %Q{<a href="#{page.outpath('.html')}">#{page.relpath}/#{page.basename}</a>}
      buf << %Q{ <a href="#{page.outpath('.json')}">(.json)</a>}
      buf << "\n"
    end
    buf << "</pre>\n"



     outpath = "#{outdir}/index.html"

     write_text( outpath, buf )
end
