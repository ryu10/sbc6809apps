10  FOR Y =  - 12 TO 12
20  FOR X =  - 39 TO 39
30 CA = X * .0458
40 CB = Y * .08333
50 A = CA
60 B = CB
70  FOR I = 0 TO 15
80 T = A * A - B * B + CA
90 B = 2 * A * B + CB
100 A = T
110  IF (A * A + B * B) > 4 THEN GOTO 200
120  NEXT I
130  PRINT " ";
140  GOTO 210
200  IF I > 9 THEN I = I + 7
205  PRINT  CHR$ (48 + I);
210  NEXT X
220  PRINT
230  NEXT Y
