####
#  to run use:
#    $ ruby ./main_chat.rb         (in /fbtxt)


##
##  check misc. formats from ai chats

$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'



txt = <<-TXT

## Common Result Formats (Inline Between Teams)
## Standard Score Format

Arsenal 2-1 Chelsea                         ## YES - Bingo!
Barcelona 0-0 Real Madrid                   ## YES - Bingo!


## With Status Inline

Arsenal 2-1 Chelsea  (FT)                   ## YES - Bingo!
Barcelona 1-1 Real Madrid  (HT)             ## YES - Bingo!
Juventus 2-2 Inter   (AET)                  ## YES - Bingo!
Liverpool 1-1 Man City   (4-3 pens)         ## YES - Bingo!


## Live Format

# note -   live (fuller) score markers (65') and (90+3') NOT supported in Football.TXT
#          change to "generic" (match) inline note  [65'] and [90+3']

## Arsenal 1-0 Chelsea (65')    --- XXXX change (65') to [65']
Barcelona 0-0 Real Madrid (HT)
## PSG 2-1 Marseille (90+3')    --- XXXX change (90+3') to [90+3']

Arsenal 1-0 Chelsea [65']
Barcelona 0-0 Real Madrid (HT)
PSG 2-1 Marseille [90+3']


## Postponed / Cancelled Format

## note - match status in parenthesis () NOT supported in Football.TXT
##           change to square bracket note [] or inline

## Arsenal vs Chelsea (PPD)           --- XXXX change (PPD) to [PPD]   or  ppd./PPD inline
## Barcelona vs Real Madrid (Postp)   --- XXXX change (Postp) to [Postp] or postp./POSTP inline
## Juventus vs Inter (Canc)           --- XXXX change (Canc) to [Canc] or  canc./CANC inline

Arsenal   v Chelsea      [PPD] 
Barcelona v Real Madrid  [Postp]
Juventus  v Inter        [Canc]

# -or-

### note - mixed-case for inline match status NOT possible
##                e.g. Canc, Postp, 
##        only ppd/ppd./PPD  or
##             postp/postp./POSTP or
##             canc/canc./CANC
##  why?  "camel-case" reserved for team names! (Canc, Postp, Aban)
##                    or v/vs/VS   (Vs, V)

Arsenal   ppd.   Chelsea 
Barcelona postp. Real Madrid 
Juventus  canc.  Inter 

# -or-

Arsenal   ppd   Chelsea 
Barcelona postp Real Madrid 
Juventus  canc  Inter 

# -or-

Arsenal ppd Chelsea 
Barcelona postp Real Madrid 
Juventus canc Inter 

# -or

Arsenal PPD Chelsea 
Barcelona POSTP Real Madrid 
Juventus CANC Inter 

# -or-

Arsenal   v Chelsea      [Postponed] 
Barcelona v Real Madrid  [Postponed]
Juventus  v Inter        [Canceled]


## Compact Plain Text Examples (League Style)

## note - rounds in Football.TXT required round marker
##       and league is usually a (document) header/heading 

## EPL – Matchday 12
Arsenal 2-1 Chelsea (FT)         ## YES - Bingo!
Man City 3-0 Tottenham (FT)      ## YES - Bingo!
## Liverpool vs Brighton (PPD)  --- XXXX change (PPD) to [PPD]   or  ppd./PPD inline


=EPL=
▪ Matchday 12
Arsenal 2-1 Chelsea (FT)
Man City 3-0 Tottenham (FT)
Liverpool vs Brighton [PPD]

## -or-

▪ EPL - Matchday 12
Arsenal 2-1 Chelsea 
Man City 3-0 Tottenham
Liverpool ppd. Brighton 


## or ultra-compact

ARS 2-1 CHE (FT)        ## YES - Bingo!
MCI 3-0 TOT (FT)        ## YES - Bingo!
## LIV vs BHA (PPD)    --- XXXX change (PPD) to [PPD]   or  ppd./PPD inline


ARS 2-1 CHE (FT)
MCI 3-0 TOT (FT)
LIV vs BHA [PPD]

## -or-

ARS 2-1 CHE 
MCI 3-0 TOT 
LIV P-P BHA 



## Using N/P (Not Played)

## in Football.TXT  - n/p only possible as inline match status
##    use [canceled] for  status note style
## Arsenal vs Chelsea (N/P)

Arsenal n/p Chelsea 
Arsenal N/P Chelsea 


## Walkover (W/O) — When & How to Use It
## Minimal

Arsenal w/o Chelsea
Arsenal W/O Chelsea
Arsenal v Chelsea   [W/O]
Arsenal v Chelsea   [WO]
Arsenal v Chelsea   [Walkover]


## Clearer

## Arsenal 3-0 Chelsea (WO)

Arsenal 3-0 Chelsea   [WO]
Arsenal 3-0 Chelsea   [W/O]

Arsenal 3-0 Chelsea  [awarded - walkout]
Arsenal 3-0 awd. Chelsea  [awarded - walkout]
Arsenal 3-0 awd. Chelsea


## Even clearer (database-friendly)
##  Arsenal 3-0 Chelsea (WO – Chelsea withdrew)

Arsenal 3-0 Chelsea [WO - Chelsea withdrew]
Arsenal 3-0 Chelsea [W/O - Chelsea withdrew]

Arsenal 3-0 Chelsea [awarded; walkout - Chelsea withdrew]
Arsenal 3-0 awd. Chelsea [walkout - Chelsea withdrew]


## Should You Include Date & Venue?
## YES — if the fixture was officially scheduled

## note - in Football.TXT 
##   use the geo marker (@) for stadium in match header

## 12.03.2026 – Emirates Stadium
## Arsenal 3-0 Chelsea (WO)

12.03.2026 @ Emirates Stadium
Arsenal 3-0 Chelsea    [WO]

12.03.2026 @ Emirates Stadium
Arsenal 3-0 Chelsea    [awarded]


## When NOT to include date/venue
## Arsenal vs Chelsea (Cancelled – competition void)

Arsenal vs Chelsea  [cancelled - competition void]


## Abandoned vs Suspended

## PSG 1-0 Marseille (Susp – 72')
## PSG 1-0 Marseille (Abd – crowd trouble)
## PSG 1-0 Marseille (Abd – result stands)

PSG 1-0 Marseille [Susp - 72']
PSG 1-0 Marseille [Abd - crowd trouble]
PSG 1-0 Marseille [Abd - result stands]

PSG 1-0 Marseille [Suspended - 72']
PSG 1-0 Marseille [Abandoned - crowd trouble]
PSG 1-0 Marseille [Abandoned - result stands]


## After Extra Time / Penalties
##  Best clarity format

Arsenal 2-2 Chelsea (AET, 4-3 pens)

## Avoid

Arsenal 2-2 (4-3) Chelsea


## Awarded Match (Different from WO)
## Arsenal 0-1 Chelsea (awarded 3-0 to Arsenal)

Arsenal 3-0 Chelsea  [awarded to Arsenal; originally 0-1]
Arsenal 3-0 awd. Chelsea  [originally 0-1]

## Short format
## Arsenal 3-0 Chelsea (Awarded)

Arsenal 3-0 Chelsea  [awarded]
Arsenal 3-0 awd. Chelsea 


## Ultra-Clean Competitive Format
## DATE – VENUE
## HOME SCORE-AWAY AWAY (STATUS)

## 12.03.2026 – Emirates Stadium
## Arsenal 2-1 Chelsea (FT)
## 
## 12.03.2026 – Emirates Stadium
## Arsenal 3-0 Chelsea (WO)
## 
## 12.03.2026 – Emirates Stadium
## Arsenal vs Chelsea (PPD)

12.03.2026 @ Emirates Stadium
Arsenal 2-1 Chelsea (FT)
 
12.03.2026 @ Emirates Stadium
Arsenal 3-0 Chelsea [WO]

12.03.2026 @ Emirates Stadium
Arsenal vs Chelsea  [PPD]

## -or-

12.03.2026 @ Emirates Stadium
Arsenal 2-1 Chelsea 

12.03.2026 @ Emirates Stadium
Arsenal 3-0 awd. Chelsea 

12.03.2026 @ Emirates Stadium
Arsenal ppd. Chelsea  

## -or-
12.03.2026 @ Emirates Stadium  Arsenal 2-1 Chelsea 
12.03.2026 @ Emirates Stadium  Arsenal 3-0 awd. Chelsea 
12.03.2026 @ Emirates Stadium  Arsenal ppd. Chelsea  

#####
## Basic League Round Format (RSSSF Style)

## England – Premier League 2025/26
## Matchday 28

12 Mar 2026  Arsenal      2-1  Chelsea
12 Mar 2026  Liverpool    3-0  Brighton
12 Mar 2026  Tottenham    1-1  Everton


= England - Premier League 2025/26
▪ Matchday 28
12 Mar 2026  Arsenal      2-1  Chelsea
12 Mar 2026  Liverpool    3-0  Brighton
12 Mar 2026  Tottenham    1-1  Everton

## Cup Format (With Extra Time & Penalties)

## FA Cup 2025/26 – Quarterfinals

12 Mar 2026  Arsenal      2-2  Chelsea  (aet, 4-3 pen)
12 Mar 2026  Liverpool    1-0  Leeds


= FA Cup 2025/26
▪ Quarterfinals
12 Mar 2026  Arsenal      2-2  Chelsea  (aet, 4-3 pen)
12 Mar 2026  Liverpool    1-0  Leeds


## 12 Mar 2026  Arsenal      0-3  Chelsea  (wo, Arsenal withdrew)
## 12 Mar 2026  Arsenal      1-0  Chelsea  (abandoned, 72')
## 12 Mar 2026  Arsenal      1-1  Chelsea  (abandoned)
## 15 Mar 2026  Chelsea      0-2  Arsenal

12 Mar 2026  Arsenal      0-3  Chelsea  [wo, Arsenal withdrew]
12 Mar 2026  Arsenal      1-0  Chelsea  [abandoned, 72']
12 Mar 2026  Arsenal      1-1  Chelsea  [abandoned]
15 Mar 2026  Chelsea      0-2  Arsenal
#-or-
12 Mar 2026  Arsenal      0-3 awd.  Chelsea  [wo, Arsenal withdrew]
12 Mar 2026  Arsenal      abd.  Chelsea  [abandoned at 1-0, 72']
12 Mar 2026  Arsenal      abd.  Chelsea  [abandoned at 1-1]
15 Mar 2026  Chelsea      0-2  Arsenal

## postponed
12 Mar 2026  Arsenal      ppd  Chelsea
## 12 Mar 2026  Arsenal  v  Chelsea  (postponed)

12 Mar 2026  Arsenal  v  Chelsea  [postponed]


########
## Full Example – League Round with Mixed Outcomes
## 
##
## England – Premier League 2025/26
## Matchday 28
##
## 12 Mar 2026  Arsenal      2-1  Chelsea
## 12 Mar 2026  Liverpool    3-0  Brighton
## 12 Mar 2026  Tottenham    ppd  Everton
## 12 Mar 2026  Fulham       0-3  Newcastle  (wo)
## 12 Mar 2026  West Ham     1-1  Aston Villa  (abandoned, 65')

= England - Premier League 2025/26
▪ Matchday 28

12 Mar 2026  Arsenal      2-1  Chelsea
12 Mar 2026  Liverpool    3-0  Brighton
12 Mar 2026  Tottenham    ppd.  Everton
12 Mar 2026  Fulham       0-3 awd.  Newcastle  
12 Mar 2026  West Ham     abd.  Aston Villa  [abandoned at 1-1, 65']


###
##  Plain text version of typical UEFA match format
## UEFA Champions League 2025/26
## Quarter-finals – First leg
##
## 12 March 2026, 21:00 CET
## London, Arsenal Stadium
##
## Arsenal FC 2-2 Chelsea FC (AET, 4-3 pens)

= UEFA Champions League 2025/26
▪ Quarter-finals - First leg


12 March 2026, 21:00 CET @ London, Arsenal Stadium
Arsenal FC 2-2 Chelsea FC (AET, 4-3 pens)

12 March 2026 21:00 CET @ London, Arsenal Stadium
Arsenal FC 2-2 Chelsea FC (AET, 4-3 pens)


## Arsenal FC 0-3 Chelsea FC (awarded, walkover)
Arsenal FC 0-3  Chelsea FC [awarded, walkover]
Arsenal FC 0-3 awd. Chelsea FC [awarded, walkover]


##
## FIFA Style (Regulatory / Global Official Record)
## FIFA World Cup 2026
## Group B – Match 17
## 12 March 2026 – Los Angeles
##
## England 2-1 USA

= FIFA World Cup 2026
▪ Group B - Match 17
12 March 2026 @ Los Angeles
England 2-1 USA

## -or- 

▪ Group B
12 March 2026 
(17) England 2-1 USA @ Los Angeles

## If penalties
## England 1-1 USA (England won 4-3 on penalties)

England 1-1 USA (win 4-3 on pens)


## If walkover
## England awarded match 3-0 (USA withdrew)

England 3-0 awd. USA [USA withdrew]
England 3-0 USA [awarded - USA withdrew]


## 12 Mar 2026  Arsenal      0-3  Chelsea  (wo)
## Arsenal FC 0-3 Chelsea FC (match awarded – Arsenal withdrew)
## Match awarded 3-0 to Chelsea (Arsenal withdrew before kick-off).

12 Mar 2026  Arsenal      0-3 awd.  Chelsea  [wo]

Arsenal FC 0-3 Chelsea FC [awarded - Arsenal withdrew]

Arsenal 0-3 awd. Chelsea
 [Match awarded to Chelsea (Arsenal withdrew before kick-off).]


##########
## STANDARD PLAYED MATCH
## 2026-03-12 | EPL | MD28 | London (Emirates Stadium) | Arsenal 2–1 Chelsea | FT |

=EPL
▪ MD28
 2026-03-12 @ London (Emirates Stadium)  Arsenal 2-1 Chelsea 
# -or- 
 2026-03-12   Arsenal 2-1 Chelsea  @ London (Emirates Stadium)

## AFTER EXTRA TIME
##  2026-03-12 | FAC | QF | London (Emirates Stadium) | Arsenal 2–2 Chelsea | AET |

=FAC
▪ QF
2026-03-12 @ London (Emirates Stadium)   Arsenal 2-2 Chelsea (AET)
# -or-
2026-03-12    Arsenal 2-2 Chelsea (AET)  @ London (Emirates Stadium)


## PENALTIES
## 2026-03-12 | FAC | QF | London (Emirates Stadium) | Arsenal 2–2 Chelsea | PEN | Chelsea won 4–3

2026-03-12 @ London (Emirates Stadium)   Arsenal 2-2 Chelsea (win 3-4 on pens) 

## WALKOVER (Home Withdrew)
## 2026-03-12 | EPL | MD28 | London (Emirates Stadium) | Arsenal 0–3 Chelsea | WO | Arsenal withdrew

2026-03-12 @ London (Emirates Stadium)   Arsenal 0-3 awd. Chelsea  [WO - Arsenal withdrew]

## ABANDONED (Result Stands)
## 2026-03-12 | EPL | MD28 | London (Emirates Stadium) | Arsenal 1–0 Chelsea | ABD | 72' crowd trouble; result stands

2026-03-12 @ London (Emirates Stadium)   Arsenal 1-0 Chelsea  [ABD - 72' crowd trouble; result stands]

## ABANDONED (Replay Ordered)
## 2026-03-12 | FAC | R3 | London (Emirates Stadium) | Arsenal 1–1 Chelsea | ABD | replay ordered

2026-03-12  @ London (Emirates Stadium)   Arsenal 1-1 Chelsea [ABD - replay ordered]
# -or-
2026-03-12  @ London (Emirates Stadium)   Arsenal abd. Chelsea [at 1-1 - replay ordered]

## POSTPONED
## 2026-03-12 | EPL | MD28 | London (Emirates Stadium) | Arsenal vs Chelsea | PPD | weather

2026-03-12  @ London (Emirates Stadium)    Arsenal vs Chelsea  [PPD - weather]
# -or-
2026-03-12  @ London (Emirates Stadium)    Arsenal ppd. Chelsea  [due to weather]


## CANCELLED (Never Played)
##  2026-03-12 | EPL | MD28 | London (Emirates Stadium) | Arsenal vs Chelsea | CANC | competition void

2026-03-12  @ London (Emirates Stadium)   Arsenal vs Chelsea  [CANC - competition void]
# -or-
2026-03-12  @ London (Emirates Stadium)   Arsenal canc. Chelsea  [competition void]


## Awarded After Match Played
##  2026-04-02 | EPL | MD30 | London (Emirates Stadium) | Arsenal 0–1 Chelsea | AWD | awarded 3–0 to Arsenal (ineligible player)

2026-04-02  @ London (Emirates Stadium)   
  Arsenal 3-0 awd. Chelsea [awarded to Arsenal; originally 0-1 (ineligible player)]

## Neutral Venue
##  2026-05-18 | UCL | Final | Munich (Allianz Arena – neutral) | Arsenal 1–0 Chelsea | FT |

2026-05-18 @ Munich (Allianz Arena - neutral)  Arsenal 1-0 Chelsea 

##
##  FIX/FIX/FIX - maybe add  ** or such for neutral marker - why? why not?
## 2026-05-18 @ Munich (Allianz Arena**)  Arsenal 1-0 Chelsea 
## 2026-05-18 @ Munich (Allianz Arena)  Arsenal* 1-0 Chelsea 
## 2026-05-18 @ Munich (Allianz Arena)  Arsenal** 1-0 Chelsea 


## Expunged Match
##   2026-02-01 | EPL | MD22 | London (Emirates Stadium) | Arsenal 2–0 Chelsea | VOID | result expunged after club removal

2026-02-01 @ London (Emirates Stadium)   Arsenal 2-0 Chelsea [void - result expunged after club removal]
2026-02-01 @ London (Emirates Stadium)   Arsenal 2-0 Chelsea [annulled - result expunged after club removal]


TXT


  parser = RaccMatchParser.new( txt, debug: true )
  tree = parser.parse
  pp tree

  if parser.errors?
    puts "-- #{parser.errors.size} parse error(s):"
    pp parser.errors
  else
    puts "--  OK - no parse errors found"
  end
  


puts "bye"