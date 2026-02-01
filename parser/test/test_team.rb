###
#  to run use
#     ruby test/test_team.rb


require_relative 'helper'

class TestTeam < Minitest::Test


def self.prepare( txt )
   names = []
   txt.each_line do |line|
       # strip comments
        line = line.strip   ## note - strip leading AND trailing whitespaces
                            ## note - trailing whitespace may incl. \n or \r\n!!!

        next if line.start_with?('#')   ###  skip comments
       
        line = line.sub( /#.*/, '' ).strip   ###  cut-off end-of line comments too
  
        next if line.empty?   ### skip blank lines

        names << line
   end
   names
end   


VALID_TEAMS = prepare(<<TXT)
Rapid Wien
1860 München
1860 Munich

Achilles'29 II
UDI'19/Beter Bed
UDI '19/Beter Bed
One/Two

V. Köln
V Köln

Naval 1° de Maio
1° de Maio

##  note - (Beer) assumed as (trailing) country code :-)
##    to fix change to "plain" - Qingdao Pijiu Beer 
##     () in team names is for now reserved (for special cases)
Qingdao Pijiu (Beer)     

Austria 2
Dnpro-1
Brighton & A
Cote'd Ivoir
ASC Monts d'Or Chasselay
Grenoble Foot 38


#####
## check minimals
A B
A
a
A1
a2
a3

A&
A'
A.



## more
Park21 Arena
Park21-Arena
Park21/Arena

21.A
21°A
21 A
21A

Group A
Group 1.A
Group 1A
Group A.1
Group A1
Matchday 1
1. Round

U21 Matzlatan
U17 Matzlatan
Bosina & Herz

### special case for 's  !!!
's Gravenwezel-Schilde
's Gravenwezel

TXT



INVALID_TEAMS = prepare(<<TXT)

#########
##  note -  (inline)  _/_ NOT allowed   (_ => space)
One / Two
Final / First Leg
Final/ First Leg
Final /First Leg


#######
##  note -  (inline)  _-_ NOT allowed   (_ => space)
Final - First Leg
Final- First Leg
Final -First Leg
ITA - FRA


############
##  note -   (inline)  _v_  NOT allowed   (reserved as match separator!!) 
Achilles'29 II v UDI'19/Beter Bed
Rapid v Austria

Rapid vs Austria     ## note - for now vs is reserved too - keep (why? why not? !!!


#####
##  note -   no space allowed in "country code" e.g.  (Army Team) 
August 1st (Army Team)


#######
###  reserved special number pairs  - note 3.12 or 5.-8. or such   
Rapid 1-1
Rapid 2:10
Rapid 2.10
Rapid 2h10

Group 1.1
2. Aufstieg 3.12
5.-8. Platz Playoffs
9.-12. Platz Playoffs
13.-16. Platz Playoffs

Rapid 2'
Rapid 45+1'
Rapid 45+


###########
##  two space rule  - cannot use two (or more) spaces inside a name!!
Rapid  Austria
Rapid 2  Austria 2
A  B


####
#  check (invalid) short versions
A-
A°

a&&&&&&
a.........
a''''''''''


12'
12°
11
11  A
1


20.45 Real Madrid


#####
### special case for 's  (must be followed by alpha e.g 's Gravenwezel-Schilde) !!!
's

TXT


## pp SportDb::Lexer::IS_TEAM_RE



def test_teams
   VALID_TEAMS.each do |team|
      m =  SportDb::Lexer._parse_team( team )
      if m
         puts "OK >#{team}<"
         assert true
      else
         puts "!! >#{team}<"         
         assert false, "is_team (regex) match failed for >#{team}<"
      end
  end

   INVALID_TEAMS.each do |team|
      m =  SportDb::Lexer._parse_team( team )
      if m
         puts "!! >#{team}<"
         assert false, "is_team (regex) match for invalid team >#{team}<"
      else
         puts "NOK >#{team}<"         
         assert true
      end
  end
end

end  # class TestTeam

