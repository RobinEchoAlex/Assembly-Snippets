;AX stores an unsigned integer x, x<999
;flip the x and store it into AX
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
   
    MOV CX,0        ;CX stores the flipped number
    MOV AX,10       ;AX stores the target number
    CMP AX,10       ;if AX<10
    JB one_digit    ;only one digit needed to be processed if AX<100
    CMP AX,100;        
    JB two_digit    ;only two digit nedded to be processed
    MOV BL,10;        
    DIV BL          ;/10 
    MOV BH,AL       ;use BH to temporarily store quotient
    MOV AL,AH       ;store the remainder into AL for MUL
    MOV BL,100      ;multiply by weight
    MUL BL            
    MOV CX,AX       ;store the fliped "last digit"
    MOV AL,BH       ;load quotient
two_digit:
    MOV BL,10
    MOV AH,0
    DIV BL          ;/10
    MOV BH,AH       ;store quotient into BH temporarily
    CBW             ;byte to word
    ADD CX,AX       ;add the fliped first number 
    MOV AL,BH       ;load quotient
    MUL BL          ;multiply by weight
one_digit:
    ADD CX,AX            
    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START




