* assist09swi.asm
* assist09 sw int params
* ex.
*       swi
*       .db brkpt
*
eot     = $04
*
inchnp	= 0	; input char in a reg - no parity
outch	= 1	; output char from a reg
pdata1	= 2	; output string
pdata	= 3	; output cr/lf then string
out2hs	= 4	; output two hex and space
out4hs	= 5	; output four hex and space
pcrlf	= 6	; output cr/lf
space	= 7	; output a space
monitr	= 8	; enter assist09 monitor
vctrsw	= 9	; vector examine/switch
brkpt	= 10	; user program breakpoint
pause	= 11	; task pause function
