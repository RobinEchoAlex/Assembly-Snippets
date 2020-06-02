data segment
    str1 db 200,0,200 dup(0)  
    str2 db 200,0,200 dup(0)
    str3 db "match$"
    str4 db "no match$"
data ends

code segment
    assume ds:data,cs:code
main proc far
    mov ax,data
    mov ds,ax 
    
    MOV AH,0AH
    LEA DX,str1
    INT 21H
    
    MOV AH,0AH
    LEA DX,str2
    INT 21H
    
    MOV SI,1
    MOV CL,str1[si]
    MOV CH,0            ;WARNING
    MOV SI,2
    
    MOV AH,0
    MOV BH,0
LOOP1:
    MOV AL,byte ptr str1[si]
    MOV BL,byte ptr str2[si]
    CMP AX,BX
    JNE NOT_EQUAL  
    INC SI
    LOOP LOOP1

    LEA DX,str3
    MOV AH,09H 
    INT 21H
    JMP FINISH
    
NOT_EQUAL:
    LEA DX,str4
    MOV AH,09H
    INT 21H
    
FINISH:
    MOV AH,4CH
    INT 21H
    
    main endp
code ends
    end main
    
