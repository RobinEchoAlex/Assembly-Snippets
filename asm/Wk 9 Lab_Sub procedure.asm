;output all prime number between 2-200

DATAS SEGMENT
    cur db 2; 
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
LOOP_S: 
    CALL cal;
    ADD cur,1        ;process next digit
    CMP cur,201      ;if cur reaches setting limit
    JZ ENDING        ;end the program
    JMP LOOP_S       ;else continue looping
    
ending:    
    MOV AH,4CH
    INT 21H
    
cal proc             ;sub procedure of calculating prime number
    MOV BL,2         ;BL = inner loop counter, 2<=BL<cur
    CMP cur,2        ;special treatment : if cur = 2
    JZ not_find      ;print it
cal_loop:            
    MOV AX,0         ;initialise
     MOV AL,cur      ;AL = number to be divided
     DIV BL          ;divide BL
     CMP AH,0        ;if it can be divide exactly
     JZ find         ;do not print it
     ADD BL,1        ;process next "j"
     CMP BL,cur      ;if BL = CUR
     JZ not_find     ;means all the number<cur have been examined 
     JMP cal_loop    ;so that it is a prime number
not_find:
    CALL print
find:
    RET
cal endp

print proc
    PUSH AX          ;protect register
    PUSH DX
    PUSH CX
    PUSH BX
    MOV BX,10        ;divider
    MOV CX,0         ;initialise
    MOV AX,0        
    MOV AL,cur       ;AX = number to be printed 
pushs:               ;divide the number from right to left and save them into stack
    mov DX,0
    DIV BX
    PUSH DX         
    ADD CX,1         ;set up loop counter for pop
    CMP AX,0        
    JZ pops
    JMP pushs
pops:
    POP dx
    ADD dl,30H
    MOV AH,2
    INT 21H
    lOOP POPS
    
sub_ending:
    MOV DL,20H       ;print a space
    MOV AH,2
    INT 21H
    
    POP BX
    POP CX
    POP DX
    POP AX
    RET
print endp

CODES ENDS
    END START



