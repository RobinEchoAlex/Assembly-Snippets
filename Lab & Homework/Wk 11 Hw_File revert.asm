;For text in ABC.txt, revert it and store into CBA.txt
;Note this program can only handle file up to 1025 bit
DATAS SEGMENT
    filename1 DB 'D:\ABC.txt',00
	filename2 DB 'D:\CBA.txt',00
	handle1 DW ?            
	handle2 DW ?
	read DB 1025 DUP(0)     ;content read
	write DB 1025 DUP(0)    ;content to write
    len DW 0
	error1 DB 'Cannot Open File!',0DH,0AH,'$'
	error2 DB 'Cannot Create File!',0DH,0AH,'$'
	error3 DB 'Read File Exception!',0DH,0AH,'$'
	error4 DB 'Write File Exception!',0DH,0AH,'$' 
DATAS ENDS

STACKS SEGMENT
    ;
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    MOV AH,3DH          ;open ABC.txt
    LEA DX,filename1
    MOV AL,0            ;NOTE likely that open in read only cause error 
    INT 21H
    JC ERR1
    MOV handle1,AX
    
    MOV AH,3CH          ;create CBA.txt
    LEA DX,filename2
    MOV CX,0                           
    INT 21H
    JC ERR2
    MOV handle2,AX

    LEA DX,read         ;DX = i 
READ_S:                 ;repeatly read file until EOF, read 255 bits every time
    MOV AH,3FH
    MOV BX,handle1
    MOV CX,255
    INT 21H
    JC ERR3 
    ADD len,AX          ;AX = length of read
    ADD DX,AX           ;i to end of file
    CMP AX,0            ;if do not read anything
    JNZ READ_S          ;the file is end and do not loop anymore
                        
                        ;start to filp the array read into write
    MOV CX,len          ;loop time = len
    LEA SI,read-1       ;DO NOT USER MOV!!! DO NOT LEA 8 BIT REGISTER
    ADD SI,len          ;iterator SI from end of 'read'->start of it
    LEA DI,write        ;iterator DI from start of 'write'->end of it
FLIP:                 
    MOV BL,[SI]         ;BL as bridge
    MOV [DI],BL         ;DO NOT USE BX!!!
    INC DI              ;j++
    DEC SI              ;i--
    LOOP FLIP
    
    MOV AH,40H          ;write to CBA.txt
    MOV DH,0
    LEA DX,write
    MOV BX,handle2
    MOV CX,len
    INT 21H
    JC ERR4
    
CLOSE_1:
    MOV AH,3EH
    MOV BX,handle1
    INT 21H
CLOSE_2:
    MOV AH,3EH
    MOV BX,handle2
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
CODES ENDS
    END START
