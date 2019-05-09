;read the resolution of a .bmp file and store it into size.txt
DATAS SEGMENT
	FILENAME1 DB 'D:\image.bmp',00
	FILENAME2 DB 'D:\size.txt',00
	HANDLE1 DW ?            
	HANDLE2 DW ?
	BUFFER DB 1024 DUP(" ") ;head information of .bmp
	DPX DB 1024 DUP(" ")    ;dimension in ascii format
	widths DB 0;
	height DB 0;
	ERROR1 DB 'Cannot Open File!',0DH,0AH,'$'
	ERROR2 DB 'Cannot Create File!',0DH,0AH,'$'
	ERROR3 DB 'Read File Exception!',0DH,0AH,'$'
	ERROR4 DB 'Write File Exception!',0DH,0AH,'$'
DATAS ENDS

STACKS SEGMENT
    ;
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS            ;see page 404 to understand the program
    MOV DS,AX
    ;
	MOV AH,3DH				;Open image.bmp
	LEA DX,FILENAME1		;DX = offset of filename
	MOV AL,0				;read only
	INT 21H
	JC ERR1					;if error occours, throw exception
    MOV HANDLE1,AX			;save file handle
    
    MOV AH,3CH				;Create size.txt
    LEA DX,FILENAME2
    MOV CX,0				;a normal file
    INT 21H
    JC ERR2
    MOV HANDLE2,AX
    
    MOV AH,3FH				;content of bmp -> buffer
    LEA DX,BUFFER
    MOV BX,HANDLE1
    MOV CX,1024             ;length of byte to read
    INT 21H
    JC ERR3
    
    LEA SI,BUFFER           ;get width and height from the infomation of the file...
    ADD SI,18               ;...note this is the position of resolution information
    MOV DL,[SI]				;DL = width
    MOV widths,DL
    ADD SI,4
    MOV DH,[SI]				;DH = height
    MOV height,DH
    
	LEA DI,DPX				;width -> buffer 
    MOV AH,0
    MOV AL,widths
 	CALL hex  
 	
 	MOV [DI],'x'            ;print a seperate symbol between width and height
 	INC DI
 	
 	MOV AH,0	            ;height -> buffer
 	MOV AL,height
 	CALL hex
	
	MOV AH,40H				;buffer -> file				
	LEA DX,DPX
	MOV BX,HANDLE2
	MOV CX,7
	INT 21H
	JC ERR4
    
CLOSE_1:
	MOV AH,3EH
	MOV BX,HANDLE1
	INT 21H
CLOSE_2:
	MOV AH,3EH
	MOV BX,HANDLE2
	INT 21H
FINISH:
    MOV AH,4CH
    INT 21H
    
ERR1:
	MOV AH,9
	LEA DX,ERROR1
	INT 21H
	JMP FINISH
ERR2:
	MOV AH,9
	LEA DX,ERROR2
	INT 21H
	JMP CLOSE_1 
ERR3:
	MOV AH,9
	LEA DX,ERROR3
	INT 21H
	JMP CLOSE_2 
ERR4:
	MOV AH,9
	LEA DX,ERROR4
	INT 21H
	JMP CLOSE_2

hex proc					;parameter:Number to write = AX
	PUSH BX
	PUSH CX
	PUSH DX 
    MOV CX,0
NOT_0:
	MOV DL,10
	DIV DL                  ;/10
	MOV BH,0
	MOV BL,AH               ;BL = remainder  
	PUSH BX                 ;store remainder into stack so write inversely later
	INC CX                  ;CX = number of digit to print
	CMP AL,0                ;if quotient = 0
	JZ LOOP_P;              ;stop dividing
	MOV AH,0                
	JMP NOT_0
	
LOOP_P:                     ;print the asciied number into buffer
	POP AX                  ;get the one digit 
	ADD AL,30H
	MOV [DI],AL
	INC DI
	LOOP LOOP_P  
	POP DX
	POP CX
	POP BX	
	ret                     ;DO NOT FORGET RET!!!			
hex endp

CODES ENDS
    END START



