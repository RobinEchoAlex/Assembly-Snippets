;AL = extract first 3 digit of BX as the last 3 digit
;add last 5 digit of CX as the first 5 digit
;store it into AL
DATAS SEGMENT
    ;
DATAS ENDS

STACKS SEGMENT
    ;
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;
    MOV BX,0F000H    ;test number
    MOV CL,13        ;times of shift
    SHR BX,CL        ;right shift BX 13 times
    
    MOV CX,16H       ;test number
    MOV AX,CX        ;store it directly into AX 
    MOV CL,3H        ;times of shift
    SHL AX,CL        ;shift AX left 3 times
    
    ADD AL,BL        ;add shifted BL
    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START


