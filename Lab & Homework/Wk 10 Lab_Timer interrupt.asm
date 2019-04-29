;print the character in the given string one by one
;with a 0.5 second time gap
DATAS SEGMENT
    string db 'welcome to asm';
    leng dw ($-string);
    i dw 0;
    count dw 1;
DATAS ENDS

STACKS SEGMENT
    ;
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
   
    MOV AL,1CH			;get the interrupt vector of timer, see page295
    MOV AH,35H
    INT 21H
    PUSH ES				;save it
    PUSH BX
    
    PUSH DS				;rewrite the no.1ch interrupt vector with procedure "delay"
    MOV DX,OFFSET PRINT	;see page295
    MOV AX,SEG PRINT
    MOV DS,AX
    MOV AL,1CH
    MOV AH,25H
    INT 21H
    POP DS
    
    IN AL,21H			;set the last digit, which represents the timer in 
    AND AL,11111110B	;the interrupt mask register 21h to 0
    OUT 21H,AL			;see page293
    STI					;allow interrput, see page292
					    
INFINITE:				;infinite loop to ensure the main program does not exit itself
    MOV CX,i			
    CMP CX,leng			;if (i>leng), all letter are printed 
    JNB RECOVER			;recover the interrrupt vector and end the program
	JMP INFINITE

RECOVER:				;recover the original interrput vector
    POP DX
    POP DS
    MOV AL,1CH
    MOV AH,25H
    INT 21H
      
    MOV AH,4CH
    INT 21H
    
PRINT PROC				;this procedure is called 18.2 times per second
						;so every 9 time it is called, print a character
	PUSH AX
	PUSH BX
	PUSH DX
	PUSH DS
	MOV AX,DATAS		;allow data segment
    MOV DS,AX			;why the program does not work if these two lines are removed?
    
    STI					;allow interrupt
	DEC count			;count--			
	JNZ exit			;do nothing
	
	MOV BX,i			;BX = i
	MOV DL,string[BX]	;DL = string[i]
	MOV AH,2			;print it
	INT 21H
	INC i
	
	MOV count,9			;set up another loop for counting 1/2 seconds
	
exit:
	CLI					;disallow interrupt
	POP DS				
	POP DX
	POP BX
	POP AX
	IRET
PRINT ENDP
	
	
CODES ENDS
    END START


