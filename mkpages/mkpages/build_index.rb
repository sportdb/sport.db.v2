
##
## todo
##    on render tree
##   - [ ]  sort keys if path is a (all-number) season
##          make latest go first e.g. 2026-27 before 1986-87 etc.!!!


###
##  build a tree from pages
##     use relpath as key for now

##
##  maybe auto-collape (w/ summary/details)
##      dirs with subdirs
##   and yes, track subdirs


def _build_tree( site )
   tree = {}

   site.each_page_with_index do |page,i|
       key = ""
       key += page.relpath
       ## strip archive/YYYYs/ for now
       key = key.sub( %r{^archive/\d{4}s/}ix, '' )

       node = tree[key] ||=[]
       node << page
   end

   tree
end


def build_index( site, outdir: )


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


    tree = _build_tree( site )


    ## note - use unicode open folder e.g. 📂
    ##    or maybe closed folder?
    folder = "\u{1F4C2}"

    tree.each do |path,pages|
       ## buf << "#{folder}#{path} (#{pages.size})\n"
       buf << "#{folder}#{path}\n"
       buf << "    "

       pages.each_with_index do |page,i|

        ## quick hack for /internationals
        ##    if dirname with leading underscore (_) incl. in basename than auto-remove!!
        ##  arab_cup/1963_arab_cup.txt
         dirname = File.basename(path)  ## note - get last entry from path (all dirs)
         basename = page.basename.sub( "_#{dirname}", '' )

         if i > 0
            buf << " · "
            buf << "\n    "    if i % 6 == 0   ## simple break after six entries for now
         end

         buf << %Q{<a href="#{page.outpath('.html')}">#{basename}</a>}
         buf << %Q{ <a href="#{page.outpath('.json')}">(.json)</a>}
       end
       buf << "\n"
    end


 #   site.each_page_with_index do |page,i|
 #     buf << %Q{<a href="#{page.outpath('.html')}">#{page.relpath}/#{page.basename}</a>}
 #     buf << %Q{ <a href="#{page.outpath('.json')}">(.json)</a>}
 #     buf << "\n"
 #   end

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
