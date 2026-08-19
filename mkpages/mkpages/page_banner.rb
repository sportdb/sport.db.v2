




## rename to build_page_banner - why? why not?
def build_banner( site:,
                  page: )


 baseurl = site.baseurl   ## add/use default - why? why not?


 edit_url = "#{baseurl}/blob/master/#{page.relpath}/#{page.basename}.txt"

 txt_url  = "#{baseurl}/raw/refs/heads/master/#{page.relpath}/#{page.basename}.txt"


 json_url = "#{page.outpath('.json')}"

## note - banner is its own pre block
banner = String.new
banner += "<pre>\n"
banner += %q{<a href="./index.html" title="Index">/</a>}
banner += " - "
banner += %Q{<a href="#{edit_url}" title="yes, you can! changes tracked @ github">view/edit this page</a>}
banner += " ("
banner += %Q{<a href="#{txt_url}" title="100% plain text, yes, ALWAYS in unicode (utf-8)">.txt</a>}
banner += ", "
banner += %Q{<a href="#{json_url}">.json</a>}
banner += ")"


banner += "\n"
banner += "</pre>\n"

banner

end