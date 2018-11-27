*       fp6809.asm
*       Floating Point entries from Basic9
*
fsub    = $f0ff         ; SUBTRACT FPA0 FROM FP NUMBER POINTED TO BY (X), LEAVE RESULT IN FPA0 (LB9B9)
fadd    = $f108         ; ADD FP NUMBER POINTED TO BY (X) TO FPA0 - LEAVE RESULT IN FPA0 (LB9C2)
fmult   = $f210         ; MULTIPLY FPA0 BY (X) - RETURN PRODUCT IN FPA0 (LBACA)
div10   = $f2c8         ; DIVIDE FPA0 BY 10 (LBB82)
fdiv    = $f2d7         ; DIVIDE FPA1 BY FPA0, leave result in FPA0 (LBB91)
load_fpa0 = $f35a       ; COPY A PACKED FP NUMBER FROM (X) TO FPA0 (LBC14)
store_fpa0 = $f37b      ; PACK FPA0 AND MOVE IT TO ADDRESS IN X (LBC35)
load_fpa1 = $f275       ; UNPACK A FP NUMBER FROM (X) TO FPA1 (LBB2F)
fout    = $f51f         ; CONVERT FP NUMBER TO ASCII STRING (X) (LBDD9)
strlit1 = $ec9a         ; Move pointer back one and then parse string from (X) (LB516)
strlit  = $ec9c         ; Scan a string from (X) (LB518)
strout  = $f0e2         ; COPY A STRING FROM (X) TO CONSOLE OUT (LB99C) = LB518 + LB99F
strprt  = $f0e5         ; print a str (X) to console out (LB99F)
tr_fpa0_fpa1 = $f3a5    ; TRANSFER FPA0 TO FPA1
fsgn    = $f3b3         ; CHECK FPA0; RETURN ACCB = 0 IF FPA0 = 0,
                        ;* ACCB = $FF IF FPA0 = NEGATIVE, ACCB = 1 IF FPA0 = POSITIVE (LBC6D)
fcmp    = $f3e6         ; COMPARE FPA0 WITH FP NUMBER POINTED TO BY (X).
                        ;* FPA0 IS NORMALIZED, (X) IS PACKED. (LBCA0)
float   = $ec78         ; CONVERT THE VALUE IN ACCD INTO A FLOATING POINT NUMBER IN FPA0
; ** FLOATING POINT ACCUMULATOR #0
; 0077 004f                    FP0EXP	RMB	1	*PV FLOATING POINT ACCUMULATOR #0 EXPONENT
; 0078 0050                    FPA0	RMB	4	*PV FLOATING POINT ACCUMULATOR #0 MANTISSA
; 0079 0054                    FP0SGN	RMB	1	*PV FLOATING POINT ACCUMULATOR #0 SIGN
; ** FLOATING POINT ACCUMULATOR #1
; 0084 005c                    FP1EXP	RMB	1	*PV FLOATING POINT ACCUMULATOR #1 EXPONENT
; 0085 005d                    FPA1	RMB	4	*PV FLOATING POINT ACCUMULATOR #1 MANTISSA
; 0086 0061                    FP1SGN	RMB	1	*PV FLOATING POINT ACCUMULATOR #1 SIGN
*
fprint  .ma             ; print fpa0 to console
        jsr fout
        jsr strlit1     ; move back 1 char to print the sign
        jsr strprt
        swi             ; print newline
        .db pcrlf
        .em
*
float_add .ma addr      ; add (addr) to fpa0, result to fpa0
        ldx #]1
        jsr fadd
        .em
*
float_sub .ma addr      ; sub fpa0 from (addr), result to fpa0
        ldx #]1
        jsr fsub
        .em
*
float_mul .ma addr      ; mutiply (addr) by fpa0, result to fpa0
        ldx #]1
        jsr fmult
        .em
*
float_copy .ma addr1, addr2 ; copy addr1..addr1+4 to addr2..addr2+4
        ldd ]1
        std ]2
        ldd ]1+2
        std ]2+2
        lda ]1+4
        sta ]2+4
        .em
*
ld_fpa0 .ma addr        ; load (addr) into fpa0
        ldx #]1
        jsr load_fpa0
        .em
*
st_fpa0 .ma addr        ; store fpa0 into (addr)
        ldx #]1
        jsr store_fpa0
        .em
