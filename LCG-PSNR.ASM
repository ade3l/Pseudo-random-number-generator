.model small
.stack 100h
.data
mult    DW  25173
incr    DW  13849          
SEED    DW  ?
uLimit  DW  13
lLimit  DW  1
.code   
start:
    MOV     AX,@data
    MOV     DS,AX
    PUSH    BP
    MOV     BP,SP
    
    CALL    createSeed 
    ;generating 10 random numbers
    MOV CX,10
    LOOP:
        CALL    genRand
        ;------Do whatever to the random number stored in DX
        DEC     CX
        CMP     CX, 0
        JNE LOOP
    MOV     AX, 4C00H
    INT     21H 


genRand PROC
    PUSH    AX
    PUSH    BX
    PUSH    CX
     
    ;calculate next value and make that the new seed
    MOV     AX, mult
    MOV     BX, SEED
    MUL     BX
    ADD     AX, incr 
    MOV     SEED, AX
    
    ;wikipedia says:
    ;"...flaw specific to LCGs is the short period of the 
    ;low-order bits when m is chosen to be a power of 2. 
    ;This can be mitigated by using a modulus larger 
    ;than the required output, and 
    ;using the most significant bits of the state."
    
    ;Dropping the 4 least significant bits becuase of this
    ;It will reduce the range of random numbers that can be generated
    ;i.e it will now be 0-4096
    ;But it is a good trade-off considering that randomness can be increased
    shr     ax, 4                                     
    
    ;Reducing the number to in the required range
    MOV     BX, uLimit
    SUB     BX, lLimit
    
    MOV     DX,0
    DIV     BX
    ADD     DX, lLimit
    
    POP     CX
    POP     BX
    POP     AX 
    RET
genRand ENDP 

createSeed PROC
    PUSH    AX
    PUSH    BX
    PUSH    CX
    PUSH    DX 
    
    ;We will use Low-order part of clock count as the seed
    MOV     AH, 00H
    INT     1AH
    MOV     SEED, DX
    
    POP     DX
    POP     CX
    POP     BX
    POP     AX 
    RET
createSeed ENDP

END





