module SportDb
class Lexer


###
## check for 
##   table (standing) lines
##
##  e.g.
##
##        Pld W D L GF-GA Pts   |  d d d d-d d
##        Pld GF-GA Pts         |  d d-d d
##        Pld Pts W D L GF-GA   |  d d d d d d-d
##
## Pld   = matches played
## GF-GA = goal for, goal against


##        Pld W D L GF-GA Pts   |  d d d d-d d
##
##  1.BRAZIL            3  2  1  0   7- 2  7
##  2.MEXICO            3  2  1  0   4- 1  7
##  3.Croatia           3  1  0  2   6- 6  3
##  4.Cameroon          3  0  0  3   1- 9  0 

TABLE_HEADING_I_RE = %r{
       \A
        [ ]*  ## ignore leading spaces (if any)
       (?<table_heading>
         \b
          P(?:ld)?  [ ]+ 
           W        [ ]+
           D        [ ]+
           L        [ ]+
           Gls      [ ]+
           Pts
        \b
         )
        [ ]*  ## ignore trailing spaces (if any) 
        \z
   }ix


####
##   1.SOLOMON I.    1  1  0  0  3- 1  3
##   2.TAHITI        1  0  0  1  1- 3  0
##   -.Cook Islands  withdrew after first match (annulled) due to Covid-19 outbreak in squad
##   -.Vanuatu       withdrew before playing any matches due to Covid-19 outbreak in squad  -->
##
##  note - starting with -. is a table note!!!


TABLE_NOTE_RE = %r{
       \A
        [ ]*  ## ignore leading spaces (if any)
           -\.
           [ ]*
       (?<table_note>
            .+?   ## note - use non-greedy       
         )
        [ ]*  ## ignore trailing spaces (if any) 
        \z
}ix

TABLE_I_RE = %r{
        (?<table>\b 
             \d{1,2} [ ]+                        # Pld
             \d{1,2} [ ]+                        # W
             \d{1,2} [ ]+                        # D
             \d{1,2} [ ]+                        # L
             (?: \d{1,3} - [ ]* \d{1,3} [ ]+ )   # GF-GA
             \d{1,3}                             # Pts   
              \b 
        )}ix

##      Pld Pts W D L GF-GA   |  d d d d d d-d
##
## 1. ARG^         3  6  3 0 0    10-4
## 2. CHI          3  4  2 0 1     5-3
## 3. FRA          3  2  1 0 2     4-3
## 4. MEX          3  0  0 0 3     4-13

TABLE_II_RE = %r{
        (?<table>\b 
             \d{1,2} [ ]+                        # Pld
             \d{1,3} [ ]+                        # Pts   
             \d{1,2} [ ]+                        # W
             \d{1,2} [ ]+                        # D
             \d{1,2} [ ]+                        # L
             (?: \d{1,3} - [ ]* \d{1,3})   # GF-GA
              \b 
        )}ix



#############################################
# map tables
#  note: order matters; first come-first matched/served

##  possible start lines for a table
##    excludes NOTE
##    and RULER (e.g. --- or) or such in the future
TABLE_RE = Regexp.union(
    TABLE_HEADING_I_RE,
    TABLE_I_RE,
    TABLE_II_RE,
)

## all possible continuation for a table
##   excludes HEADING
TABLE_MORE_RE = Regexp.union(
    TABLE_NOTE_RE,
    TABLE_I_RE,
    TABLE_II_RE,
)


end  #   class Lexer
end  # module SportDb
