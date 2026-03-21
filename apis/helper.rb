require 'cocos'   ## check if incl webclient already?
require 'webclient'



def write_json_v2( path, data )

   ## hack - use pretty_inspect for json pretty print         
    txtjson =  data.pretty_inspect 
 
    txtjson = txtjson.gsub( '=>', ': ' )
    txtjson = txtjson.gsub( /\bnil\b/, 'null' )

    ## double check for syntax errors
    json = JSON.parse( txtjson )

    write_text( path, txtjson )
end




def fetch_json( url, path=nil, headers: nil )
  res = if headers
            Webclient.get( url, headers: headers )
        else
            Webclient.get( url )
        end

  if res.status.ok?
    data = res.json
    pp data

    write_json_v2( path, data )    if path

    data
  else
    puts "!! ERROR  #{res.status.code} #{res.status.message}"
    exit 1
  end
end

