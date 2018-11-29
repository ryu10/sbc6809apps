; fp_entries.s
; fp entries in Applesoft ROM
;
; 11/03/2018 ryu10
;
FSUB	= $e7a7
FSUBT	= $e7aa
FADD	= $e7be
FADDT	= $e7c1
NORMALIZE_FAC1 = $e829
FMULT	= $e97f
FMULTT	= $e982
LOAD_ARG_FROM_YA = $e9e3
MUL10	= $ea39
DIV10	= $ea55
DIV	= $ea5e
FDIVT	= $ea66
LOAD_FAC_FROM_YA = $eaf9
COPY_ARG_TO_FAC = $eb53
COPY_FAC_TO_ARG_ROUNDED = $eb63
SIGN	= $eb82
FLOAT	= $eb93
FCOMP	= $ebb2
FIN	= $ec4a
FOUT    = $ed34
NEGOP   = $eed0
STORE_FAC_AT_YX_ROUNDED = $eb2b ; ROUND FAC, AND STORE AT (Y,X)
; print entries in Applesoft ROM
STROUT  = $db3a ;   MAKE (Y,A) PRINTABLE
STRLIT  = $e3e7 ; Callied in pair with FOUT
STRPRT  = $db3d ; PRINT STRING AT (FACMO,FACLO)
PRSTRING = $dacf ; print string?
;
.macro float_add addr
        lda #<addr
        ldy #>addr
        jsr FADD
.endmacro
;
.macro float_sub addr
        lda #<addr
        ldy #>addr
        jsr FSUB
.endmacro
;
.macro float_mul addr
        lda #<addr
        ldy #>addr
        jsr FMULT
.endmacro
;
.macro float_load addr
        lda #<addr
        ldy #>addr
        jsr LOAD_FAC_FROM_YA
.endmacro;
;
.macro float_store addr
        ldx #<addr
        ldy #>addr
        jsr STORE_FAC_AT_YX_ROUNDED
.endmacro
;
.macro float_copy src,dest
        lda src
        sta dest
        lda src+1
        sta dest+1
        lda src+2
        sta dest+2
        lda src+3
        sta dest+3
        lda src+4
        sta dest+4
.endmacro
;
.macro float_print var
        lda #<var
        ldy #>var
        jsr LOAD_FAC_FROM_YA
        jsr FOUT        ; put the result into a string (Y,A)
        jsr STRLIT ; print?
        jsr STRPRT ; print?
.endmacro
