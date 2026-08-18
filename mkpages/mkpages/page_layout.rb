


##
##  find a better name e.g. build_page_layout or such - why? why not?

def build_layout( title:,
                  body:,
                  banner: nil )


footer = <<HTML
<hr>
<pre>
 &lt;/&gt; <a href="https://github.com/openfootball">About this site</a>
     Patches, suggestions, and comments are welcome.
</pre>
HTML

content = String.new
content += banner   if banner
content += body
content += footer   if footer


page = String.new
   page += <<HTML
<!DOCTYPE html>
<html>
<head>
   <meta charset="utf-8">
   <title>#{title}</title>
   <link rel="stylesheet" href="style.css">
</head>
<body>
#{content}
</body></html>
HTML


page

end