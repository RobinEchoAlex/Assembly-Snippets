;calculate the sum of 1-500's single digit
;count the time that a number's single digit's sum is 4's multiple
;for instance, 123's single digit's sum is 1+2+3=6  
DATAS SEGMENT
    SINGLE_SUM DW 0
    ALL_SUM DW 0
    COUNT_4 DW 0
    NUMBER_10 DW 10
    NUMBER_4 DW 4
DATAS ENDS

STACKS SEGMENT
    ;
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
     
    MOV CX,500 				; SET COUNTDOWN
    MOV AX,0;
    
AGAIN:
	POP AX;
    ADD AX,1;
    PUSH AX;
    MOV SINGLE_SUM,0;
    
	DIVIDE:
		MOV DX,0
	    DIV NUMBER_10		;/10
	    ADD SINGLE_SUM,DX	;store remainder into single_sum
	    CMP AX,0			;if quotient=0
		JNZ DIVIDE;         ;stop further divide	
				
		MOV DX,0
		MOV AX,SINGLE_SUM;   
		DIV NUMBER_4		;/4     
		CMP DX,0			;if quotient=0
		JNZ LOOPS			;if quotient!=0 jump
		ADD COUNT_4,1;		;count_4 ++
		
LOOPS:
	MOV BX,SINGLE_SUM		;add the digit sum of a number into total sum via BX
	ADD ALL_SUM,BX;
    LOOP AGAIN				;process next number
    
    MOV DX,ALL_SUM			;print total sum
    MOV CX,COUNT_4;
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START




