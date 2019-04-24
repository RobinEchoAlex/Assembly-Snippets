;Print fliped binary number stored in AX
;and print it in hex
DATAS SEGMENT
	SUM DW 0;
	WEIGHT DB 15;
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
    
    MOV AX,0ABCDH;
    MOV BX,AX
    MOV CX,16	;loop counter
LOOP_S:
	ROR BX,1	;judge whether the last digit is 1
	JB ONE		;jump if 1
	MOV DL,30H	;else zero,print 0
	MOV AH,2
	INT 21H
	JMP IF_ENDS	
ONE:MOV DL,31H 	;if 1,print 1
	MOV AH,2
	INT 21H
	MOV AX,1		
	PUSH CX 	;protect loop counter 
	MOV CL,WEIGHT;move to the right position in the fliped number
	SHL AX,CL
	ADD SUM,AX
	POP CX		;load loop counter
IF_ENDS:		;Process next digit on the right
	SUB WEIGHT,1;the position in the fliped number --
	LOOP LOOP_S	;loop 16 times to process all digits
				;start printing hex
	MOV DL,20H	;print a space
	MOV AH,2;
	INT 21H;
	MOV BX,SUM;
HEXPRINT_START:
	MOV CH,4
ROTATE:
	MOV CL,4
	ROL BX,CL
	MOV AL,BL
	AND AL,0FH	;mask off left digit
	ADD AL,30H
	CMP AL,3AH	;if >9
	JL PRINTIT	;if digit=0-9 JUMP
	ADD AL,7H	;else A-F, add 7H
PRINTIT:
	MOV DL,AL	;Output a hex digit
	MOV AH,2
	INT 21H
	DEC CH
	JNZ ROTATE
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START



