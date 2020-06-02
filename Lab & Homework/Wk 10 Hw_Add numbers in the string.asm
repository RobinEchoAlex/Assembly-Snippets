;for the string that user inputs
;calculate the sum of all the decimal digits in it
;store it into AX
;e.g. for"1a2b3c", AX = 6
DATAS SEGMENT
    SUM DB 0
DATAS ENDS

STACKS SEGMENT
    ;
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    MOV BX,0
LOOP_S: 
    MOV AH,01
    INT 21H
    CMP AL,0DH    ;CR
    JZ FINISH
    CMP AL,0AH    ;LF
    JZ FINISH
    CMP AL,'0'
    JB LOOP_S
    CMP AL,'9'
    JA LOOP_S
    
    ADD AL,-30H    ;from ascii to real value
    ADD SUM,AL
    JMP LOOP_S
FINISH: 
    MOV AH,0  
    MOV AL,SUM
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START


