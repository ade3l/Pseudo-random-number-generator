.model small
.stack 100h
.data
mult    DW  17652
incr    DW  21658

.code
MOV     AX,@data
MOV     DS,AX

MOV     AH,00H
INT     1AH 

MOV     AX, mult
MUL     DX

MOV     AX, incr
ADD     DX, incr

INT     3h
END





