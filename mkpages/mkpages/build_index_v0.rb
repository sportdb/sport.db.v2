

def build_index_v0( site, outdir: )


    ###
    ##  note - add a generated on tooltip (via title attrib)
    ##             e.g. generated on 2026-08-25 15:51:43 UTC

    buf = String.new

    buf << "<pre>\n"
    buf << %Q{<span title="generated on #{Time.now.utc}">#{site.pages.size} football.txt page(s)</span>}
    buf << %Q{ @ <a href="https://github.com/#{site.repo}">#{site.repo}</a>:}
    buf << "\n"


#############
##   check for errors   with details (hide/show)

    err_page_count = 0   ### count pages/docs with errors
    buferr = String.new
    site.each_page_with_index do |page,i|

      if page.errors?
         buferr << %Q{<a href="#{page.outpath('.html')}">#{page.relpath}/#{page.basename}</a>}
         buferr << " - #{page.errors.size} parse error(s):\n"
         buferr << page.errors.pretty_inspect
         buferr << "\n"

         err_page_count += 1
      end
    end


    ###
    ##  use new pre block for error

    if !buferr.empty?
      buf << "</pre>\n"

      buf << "<pre class='errors'>"
      buf << "<details><summary>!! football.txt format errors found in #{err_page_count} page(s)</summary>\n\n"
      buf << buferr
      buf << "</details></pre>\n"

      buf << "<pre>\n"
    end


    site.each_page_with_index do |page,i|
      buf << %Q{<a href="#{page.outpath('.html')}">#{page.relpath}/#{page.basename}</a>}
      buf << %Q{ <a href="#{page.outpath('.json')}">(.json)</a>}
      buf << "\n"
    end
    buf << "</pre>\n"



    html = <<HTML
<!DOCTYPE html>
<html>
<head>
   <meta charset="utf-8">
   <title>football.txt pages @ #{site.repo}</title>
   <link rel="stylesheet" href="style.css">
</head>
<body>
#{buf}
</body>
</html>
HTML

     outpath = "#{outdir}/index.html"

     write_text( outpath, html )
end
