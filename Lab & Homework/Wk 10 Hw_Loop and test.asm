;detect whether '0110' appears in number stored in AX
;if yes, print YES, else print NO
DATAS SEGMENT
    yes_s db 'YES','$'           ;!!!set db not dw
    no_s db 'NO','$'             ;!!!if no.9 function of dos is called, the string...
DATAS ENDS                       ;...should ends with '$' 

STACKS SEGMENT
    ;
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    MOV AX,434BH
    MOV CX,13                    ;time of loop
    
LOOP_S:
    MOV DX,AX
    ADD DL,-0110B                ;if the last 4 digit is 0110
    TEST DL,0FH                    
    JZ YES                       ;print YES
    SHR AX,1                    
    LOOP LOOP_S
    JMP NO
YES:
    MOV DX,offset yes_s          ;!!!mov offset
    MOV AH,9
    INT 21H
    JMP FINISH
NO:
    MOV DX,offset no_s
    MOV AH,9
    INT 21H
    JMP FINISH
FINISH:
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START



