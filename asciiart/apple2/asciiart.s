; ASCIIART.s
; Mendelbrot Set Demo
;
; 11/03/2018 ryu10
;
; Preambles
.import __STARTUP_LOAD__, __BSS_LOAD__ ; Linker generated

.segment "EXEHDR"
.addr __STARTUP_LOAD__   ; Start address
.word __BSS_LOAD__ - __STARTUP_LOAD__ ; Size

.segment "STARTUP"
;
; FP entries
.include "fp_entries.s"
;
; Monitor entries
COUT    = $fded
COL80   = $c300
;
; Constants
YMIN    = -12+256
YMAX    = 12
XMIN    = -39+256
XMAX    = 39
IMIN    = 0
IMAX    = 15
CHAR_A  = 'A'+$80
CHAR_0  = '0'+$80
CHAR_SP = ' '+$80
NEWLINE = 13
;
;       ORG $0803
        jsr COL80
;       FOR Y = -12 TO 12
        lda #YMIN
        sta VY
;       FOR X = -39 to 39
LOOPY:  lda #XMIN
        sta VX
LOOPX:
;       CA = X * 0.0458
        lda VX
        jsr FLOAT ; FAC = X
        float_mul AX ; FAC = FAC * AX
        float_store CA ; CA = FAC
;       CB = Y * 0.08333
        lda VY
        jsr FLOAT ; FAC = Y
        float_mul AY ; FAC = FAC * AY
        float_store CB ; CB = FAC
;       A = CA
        float_copy CA, VA
        ; float_load CA
        ; float_store VA
;       B = CB
        float_copy CB, VB
        ; float_load CB
        ; float_store VB
;       FOR I = 0 TO 15
        lda #IMIN
        sta VI
LOOPI:
;       T = A * A - B * B + CA
        float_load VA
        float_mul VA
        float_store VT
;        jsr COPY_FAC_TO_ARG_ROUNDED ; ARG = FAC
        float_load VB
        float_mul VB
;        jsr FSUBT ; FAC = ARG - FAC *** FUSBT does not work
        float_sub VT
        float_add CA
        float_store VT
;       B = 2 * A * B + CB
        lda #2
        jsr FLOAT ; FAC = 2
        float_mul VA ; FAC = FAC * A
        float_mul VB ; FAC = FAC * B
        float_add CB ; FAC = CB + FAC
        float_store VB ; B = FAC
;       A = T
        float_copy VT, VA
        ; float_load VT
        ; float_store VA
;       IF (A*A + B*B) > 4 THEN GOTO 200
        float_load VA
        float_mul VA
        float_store VT
        float_load VB
        float_mul VB
        float_add VT
        jsr COPY_FAC_TO_ARG_ROUNDED
        float_store VT
        lda #4
        jsr FLOAT
;        jsr FSUBT ; FAC = ARG - FAC *** FUSBT does not work
        float_sub VT
        jsr SIGN
        cmp #0
        bpl L200
;       NEXT I
        ldx VI
        inx
        stx VI
        cpx #IMAX+1
        beq QUITI
        jmp LOOPI
QUITI:
;       PRINT " ";
        lda #CHAR_SP
        jsr COUT
;       GOTO 210
        jmp L210
L200:
;       IF I > 9 THEN I = I + 7
;       PRINT CHR$(48 + I);
        lda VI
L200A:  cmp #10
        bpl L200B
        clc             ; I = 0..9
        adc #CHAR_0
        jmp L200P
L200B:  clc             ; I = 10..15
        adc #CHAR_A-10
L200P:  jsr COUT
L210:
;       NEXT X
        ldx VX
        inx
        stx VX
        cpx #XMAX+1
        beq QUITX
        jmp LOOPX
QUITX:
;       PRINT
        lda #NEWLINE
        jsr COUT
;       NEXT Y
        ldx VY
        inx
        stx VY
        cpx #YMAX+1
        beq QUITY
        jmp LOOPY
QUITY:
        rts
;       end
;
; variables
.segment "DATA"
VX:     .byt $00
VY:     .byt $00
VI:     .byt $00
AX:     .byt $7c,$3b,$98,$c7,$e2 ; float 0.0458
AY:     .byt $7d,$2a,$a8,$eb,$46 ; float 0.08333
VA:     .byt $00,$00,$00,$00,$00 ; float A
VB:     .byt $00,$00,$00,$00,$00 ; float B
CA:     .byt $00,$00,$00,$00,$00 ; float CA
CB:     .byt $00,$00,$00,$00,$00 ; float CB
VT:     .byt $00,$00,$00,$00,$00 ; float T
;       end
