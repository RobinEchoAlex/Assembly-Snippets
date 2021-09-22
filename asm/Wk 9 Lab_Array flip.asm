;flip a array, manipulate directly on itself
;the sub procedure should be reuseable
DATAS SEGMENT
    array DW 1,2,3,4,5,6
    len DW ($-ARRAY)/2
    table DW 20 dup(?)
DATAS ENDS

STACKS SEGMENT
    ;
STACKS ENDS

  
CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    MOV table,offset array
    MOV table+2,offset len
    mov bx,offset table
    call flip
    MOV AH,4CH
    INT 21H
    
flip proc
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI
    MOV SI,[BX]                  ;SI = offset array
    MOV DI,[BX+2]                ;DI = offset len
    MOV CL,[DI]                  ;CL = len
    MOV AX,CX                    ;AX = len
    SHL AX,1                    
    ADD AX,-2                    ;AX = physical len
    SHR CX,1                     ;CL = timeofloop = len/2
LOOP_S:                          ;AX = offset of letter number to exchange, based on former number
    MOV DX,[si]                  ;DX = former number
    PUSH SI
    ADD SI,AX                    ;pointer -> latter number 
    MOV DI,[si]                  ;DI = latter number            
    MOV [si],DX                  ;latter = former
    POP SI                       ;pointer -> former number
    MOV [si],DI                  ;former = latter
    ADD SI,2                     ;pointer ++
    ADD AX,-4                    ;set offset
    DEC CX                       ;loop control
    CMP CX,0
    JG LOOP_S
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    ret
flip endp


CODES ENDS
    END START









