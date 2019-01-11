* asciiart.asm
* Mandelbrot set asciiart program for SBC6809 w/Basic9 FP routines
*
*  11/22 ryu10
*
* (directives and macros in sbasm)
*
*       TTL asciiart.asm
        .cr 6809
        .tf asciiart.s19,s19
        .lf asciiart.list
        .sf asciiart.sym
* constants
ymin    = -12+256
ymax    = 12
xmin    = -39+256
xmax    = 39
imin    = 0
imax    = 15
char_A  = 'A
char_0  = '0
char_sp = ' ; the whitespace would be trimmed without this comment
* include Basic9 FP entries / Assist09 swi services
        .in fp6809      ; include fp6809.asm
        .in assist09swi ; include assist09swi.asm
*
        .sm code
        .or $6000
* FOR Y = -12 TO 12
        lda #ymin
        sta vy
* FOR X = -39 to 39
loopy   lda #xmin
        sta vx
loopx
* CA = X * 0.0458
        clra
        ldb vx
        bpl ll1
        lda #$ff         ; vx is negative
ll1     jsr float       ; fpa = float(vx)
        >float_mul ax    ; fpa = fpa * 0.0458
        >st_fpa0 ca      ; ca = fpa
* CB = Y * 0.08333
        clra
        ldb vy
        bpl ll2
        lda #$ff         ; vy is negative
ll2     jsr float       ; fpa = float(vy)
        >float_mul ay   ; fpa = fpa * 0.08333
        >st_fpa0 cb     ; cb = fpa
* A = CA
        >float_copy ca, va
* B = CB
        >float_copy cb, vb
* FOR I = 0 TO 15
        lda #imin
        sta vi
loopi
* T = A * A - B * B + CA
        >ld_fpa0 va
        >float_mul va
        >st_fpa0 vt
        >ld_fpa0 vb
        >float_mul vb
        >float_sub vt
        >float_add ca
        >st_fpa0 vt
* B = 2 * A * B + CB
        ldd #2
        jsr float
        >float_mul va
        >float_mul vb
        >float_add cb
        >st_fpa0 vb
* A = T
        >float_copy vt, va
* IF (A*A + B*B) > 4 THEN GOTO 200
        >ld_fpa0 va
        >float_mul va
        >st_fpa0 vt
        >ld_fpa0 vb
        >float_mul vb
        >float_add vt
        >st_fpa0 vt
        ldd #4
        jsr float
        >float_sub vt    ; fpa0 = (A^2 + B^2) - 4
        >st_fpa0 vt
        jsr fsgn
        tstb
        bpl l200     ; fpa0 > 0?
* NEXT I
        lda vi
        inca
        sta vi
        cmpa #imax+1
        beq quiti
        jmp loopi
quiti
* PRINT " ";
        lda #char_sp
        swi
        .db outch
* GOTO 210
        bra l210
l200
        ldx #vi
* IF I > 9 THEN I = I + 7
* PRINT CHR$(48 + I);
        lda vi
l200a   cmpa #10
        bpl l200b
        adda #char_0
        bra l200p
l200b   adda #char_A-10
l200p   swi
        .db outch
l210
* NEXT X
        lda vx
        inca
        sta vx
        cmpa #xmax+1
        beq quitx
        jmp loopx
quitx
* PRINT
        swi
        .db pcrlf
* NEXT Y
        lda vy
        inca
        sta vy
        cmpa #ymax+1
        beq quity
        jmp loopy
quity
        swi
        .db brkpt
*       end
* variables
vx      .db $00
vy      .db $00
vi      .db $00
ax      .db $7c,$3b,$98,$c7,$e2 ; float 0.0458
ay      .db $7d,$2a,$a8,$eb,$46 ; float 0.08333
va      .db $00,$00,$00,$00,$00 ; float a
vb      .db $00,$00,$00,$00,$00 ; float b
ca      .db $00,$00,$00,$00,$00 ; float ca
cb      .db $00,$00,$00,$00,$00 ; float cb
vt      .db $00,$00,$00,$00,$00 ; float t
