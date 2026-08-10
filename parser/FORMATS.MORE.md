# (More) Football.TXT Format Notes


- [ ] add new "top-level" props (for tournament/competition) to worldcup  e.g.

```
Host:    Uruguay
Hosts:   USA, Canada, Mexico    # or  (double space)
Hosts:   USA  Canada  Mexico

Hosts:   Japan, South Korea     # or   (double space)
Hosts:   Japan   South Korea
```




```
Edition:  1

## maybe (no need to extract from title?)
Season:  1930


ground mixes venue(stadium) and location(city)


match status with possible values:

- scheduled / timed
- live
- finished
- postponed
- cancelled
- abandoned
- awarded


- [ ]  add GK/DF/MF/FW possibly to lineup
        - note: MUST be separated by TWO spaces

ARGENTINA:
 GK  Emiliano Martínez
 DF  Nahuel Molina -> Gonzalo Montiel @91'
 DF  Cristian Romero
 DF  Nicolás Otamendi
 DF  Nicolás Tagliafico -> Paulo Dybala @120+1'
 -
 MF  Rodrigo De Paul -> Leandro Paredes @102'
 MF  Enzo Fernández
 MF  Alexis Mac Allister -> Germán Pezzella @116'
 -
 FW  Lionel Messi
 FW  Julián Álvarez -> Lautaro Martínez @102'
 FW  Ángel Di María -> Marcos Acuña @64'

Coach: Lionel Scalon


▪Final▪
18 December 2022 @ Lusail, Lusail Stadium
Attendance: 88_966
Referee: Szymon Marciniak (Poland)

ARGENTINA 3-3 FRANCE [after extra time, Argentina won 4-2 on penalties]


## allow/use city(name), date e.g.

▪Final▪
Lusail, 18 December 2022 - Lusail Stadium
Attendance: 88_966
Referee: Szymon Marciniak (Poland)

```