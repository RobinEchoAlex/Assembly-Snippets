;given a number in AX
;count how many "1" is in the binary form of the number
;save the results into BX
;and print it on the screen in hex

DATAS SEGMENT
 	SUM DW 0		;time of "1"'s appearance
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
    MOV AX,0FFFH;
	MOV CX,16 		;loop counter
LOOP_START:
	SHR AX,1		;move the last digit into CF
    JNC NOT_1		;is 1 or not ?
    ADD SUM,1		;if it is 1,counter++ 
NOT_1:    
	LOOP LOOP_START	;loop 16 times
	MOV BX,SUM		;store the sum into BX,as the requirement
					;finish adding the count of 1
					;output the sum start
	CMP SUM,16		;<16 or not ?
	JB BELOW_16		;jump if <16
	MOV DL,31H		;print 10Hex
	MOV AH,2		
	INT 21H
	
	MOV DL,30H
	MOV AH,2
	INT 21H
	JMP CODE_END	;finish
BELOW_16:
	MOV DX,SUM		;store the sum into DX
	CMP SUM,10		;<10 or not?
	JB BELOW_10
	ADD DX,7H   	;addtionally add 7 if A-F,see Ascii table
BELOW_10:
	ADD DX,30H		;add to the ascii of the number

	MOV AH,2
	INT 21H
		
CODE_END:
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START


