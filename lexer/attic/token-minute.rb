
##   goal types
# (pen.) or (pen) or (p.) or (p)
## (o.g.) or (og)
##   todo/check - keep case-insensitive 
##                   or allow OG or P or PEN or
##                   only lower case - why? why not?
GOAL_PEN_RE = %r{
   (?<pen> \(
           (?:pen|p)\.?
           \)
    )
}ix
GOAL_OG_RE = %r{
   (?<og> \(
          (?:og|o\.g\.)
          \)
   )
}ix
