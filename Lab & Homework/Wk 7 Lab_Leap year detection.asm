; leap year detection
; important notice of program
; 1. use the push&pop to save number temporaily
; 2. carefully treat the length of number when carry out division

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

    MOV AX,2010	;year to detect
    PUSH AX     ;save the year since DIV will override AX
    MOV DX,0	
    MOV BX,400
    DIV BX      ;/400
    CMP DX,0    ;test whether /400's remainder is 0
    POP AX   	;load year
    JZ Y        ;if x/400=0, it is leap year
    TEST AX,0003;test whether the last 2 digit is 0
    JNZ N       ;if /4!=0, not leap year
    MOV BL,100  
    DIV BL      ;/100
    CMP AH,0
    JNZ Y		;if /100!=0, it is leap year
    JZ N		;else not leap year 
Y:   
    MOV BX,'Y'	;59H
    JMP FINISH
N:
    MOV BX,'N'	;4EH
FINISH:
	MOV AH,4CH
    INT 21H
    
    
CODES ENDS
    END START




