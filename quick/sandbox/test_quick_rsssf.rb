#######
# test search (struct convenience) helpers/methods

## note: use the local version of gems
$LOAD_PATH.unshift( File.expand_path( '../parser/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../score-formats/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../sportdb-structs/lib' ))
$LOAD_PATH.unshift( File.expand_path( './lib' ))


## our own code
require 'sportdb/quick'


OPENFOOTBALL_PATH = '../../../openfootball'


SportDb::MatchTree.debug = true


path =  "#{OPENFOOTBALL_PATH}/euro/rsssf/60e.txt"

matches = SportDb::QuickMatchReader.read( path )
## pp matches

puts
puts "  try json for matches:"
data = matches.map {|match| match.as_json }
pp data

puts "bye"

__END__

- [ ] fix "compact" heading parse 
- [ ] check geo name with ()  - split or keep as is - why? why not?

!! WARN - parse error (tokenize) - skipping any match>=< @0,1 in line >=European Championship 1960=<
!! WARN - parse error (tokenize) - skipping any match>E< @1,2 in line >=European Championship 1960=<
!! WARN - parse error (tokenize) - skipping any match>u< @2,3 in line >=European Championship 1960=<
!! WARN - parse error (tokenize) - skipping any match>r< @3,4 in line >=European Championship 1960=<
!! WARN - parse error (tokenize) - skipping any match>o< @4,5 in line >=European Championship 1960=<
!! WARN - parse error (tokenize) - skipping any match>p< @5,6 in line >=European Championship 1960=<
!! WARN - parse error (tokenize) - skipping any match>e< @6,7 in line >=European Championship 1960=<
!! WARN - parse error (tokenize) - skipping any match>a< @7,8 in line >=European Championship 1960=<
!! WARN - parse error (tokenize) - skipping any match>n< @8,9 in line >=European Championship 1960=<
!! WARN - parse error (tokenize) - skipping any match>1< @23,24 in line >=European Championship 1960=<
!! WARN - parse error (tokenize) - skipping any match>9< @24,25 in line >=European Championship 1960=<
!! WARN - parse error (tokenize) - skipping any match>6< @25,26 in line >=European Championship 1960=<
!! WARN - parse error (tokenize) - skipping any match>0< @26,27 in line >=European Championship 1960=<
!! WARN - parse error (tokenize) - skipping any match>=< @27,28 in line >=European Championship 1960=<
!! WARN - parse error (tokenize) - skipping any match>=< @0,1 in line >==Qualifying Stage==<
!! WARN - parse error (tokenize) - skipping any match>=< @1,2 in line >==Qualifying Stage==<
!! WARN - parse error (tokenize) - skipping any match>Q< @2,3 in line >==Qualifying Stage==<
!! WARN - parse error (tokenize) - skipping any match>u< @3,4 in line >==Qualifying Stage==<
!! WARN - parse error (tokenize) - skipping any match>a< @4,5 in line >==Qualifying Stage==<
!! WARN - parse error (tokenize) - skipping any match>l< @5,6 in line >==Qualifying Stage==<
!! WARN - parse error (tokenize) - skipping any match>i< @6,7 in line >==Qualifying Stage==<
!! WARN - parse error (tokenize) - skipping any match>f< @7,8 in line >==Qualifying Stage==<
!! WARN - parse error (tokenize) - skipping any match>y< @8,9 in line >==Qualifying Stage==<
!! WARN - parse error (tokenize) - skipping any match>i< @9,10 in line >==Qualifying Stage==<
!! WARN - parse error (tokenize) - skipping any match>n< @10,11 in line >==Qualifying Stage==<
!! WARN - parse error (tokenize) - skipping any match>g< @11,12 in line >==Qualifying Stage==<
!! WARN - parse error (tokenize) - skipping any match>S< @13,14 in line >==Qualifying Stage==<
!! WARN - parse error (tokenize) - skipping any match>t< @14,15 in line >==Qualifying Stage==<
!! WARN - parse error (tokenize) - skipping any match>a< @15,16 in line >==Qualifying Stage==<
!! WARN - parse error (tokenize) - skipping any match>g< @16,17 in line >==Qualifying Stage==<
!! WARN - parse error (tokenize) - skipping any match>e< @17,18 in line >==Qualifying Stage==<
!! WARN - parse error (tokenize) - skipping any match>=< @18,19 in line >==Qualifying Stage==<
!! WARN - parse error (tokenize) - skipping any match>=< @19,20 in line >==Qualifying Stage==<
!! WARN - parse error (tokenize geo) - skipping any match>(< @20,21 in line >05.04.1959 @ Dublin (Dalymount Park)<
!! WARN - parse error (tokenize geo) - skipping any match>D< @21,22 in line >05.04.1959 @ Dublin (Dalymount Park)<
!! WARN - parse error (tokenize geo) - skipping any match>a< @22,23 in line >05.04.1959 @ Dublin (Dalymount Park)<
!! WARN - parse error (tokenize geo) - skipping any match>l< @23,24 in line >05.04.1959 @ Dublin (Dalymount Park)<
!! WARN - parse error (tokenize geo) - skipping any match>y< @24,25 in line >05.04.1959 @ Dublin (Dalymount Park)<
!! WARN - parse error (tokenize geo) - skipping any match>m< @25,26 in line >05.04.1959 @ Dublin (Dalymount Park)<
!! WARN - parse error (tokenize geo) - skipping any match>o< @26,27 in line >05.04.1959 @ Dublin (Dalymount Park)<
!! WARN - parse error (tokenize geo) - skipping any match>u< @27,28 in line >05.04.1959 @ Dublin (Dalymount Park)<
!! WARN - parse error (tokenize geo) - skipping any match>n< @28,29 in line >05.04.1959 @ Dublin (Dalymount Park)<
!! WARN - parse error (tokenize geo) - skipping any match>t< @29,30 in line >05.04.1959 @ Dublin (Dalymount Park)<
!! WARN - parse error (tokenize geo) - skipping any match>P< @31,32 in line >05.04.1959 @ Dublin (Dalymount Park)<
!! WARN - parse error (tokenize geo) - skipping any match>a< @32,33 in line >05.04.1959 @ Dublin (Dalymount Park)<
!! WARN - parse error (tokenize geo) - skipping any match>r< @33,34 in line >05.04.1959 @ Dublin (Dalymount Park)<
!! WARN - parse error (tokenize geo) - skipping any match>k< @34,35 in line >05.04.1959 @ Dublin (Dalymount Park)<
!! WARN - parse error (tokenize geo) - skipping any match>)< @35,36 in line >05.04.1959 @ Dublin (Dalymount Park)<
