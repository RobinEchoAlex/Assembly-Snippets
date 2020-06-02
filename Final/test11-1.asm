DATA segment
    digit db 0
    ndigit db 0
data ends

code segment
    assume ds:data,cs:code
main proc far
    MOV ax,data
    MOV ds,ax
    
    ;accept char  
next:mov ah,01h
    int 21h
    ;judge enter
    cmp al,0dh
    jz exit
    ;judge
    cmp al,30h
    jb nondigit
    cmp al,39h
    ja nondigit
    inc digit
    jmp next
nondigit:    
    inc ndigit
    jmp next
exit:     
    MOV CX,0
    mov al,digit
    mov ah,0
continue: mov dx,0
    mov si,10
    div si
    push DX
    INC CX
    CMP AX,0
    JNZ continue    
    
l1: POP DX
    ADD DX,30H
    MOV AH,02H
    INt 21h
    LOOP L1           
    
    MOV CX,0
    mov al,ndigit
    mov ah,0
c2: mov dx,0
    mov si,10
    div si
    PUSH DX
    INC CX
    CMP AX,0
    JNZ c2
    
l2: POP DX
    ADD DX,30H
    MOV AH,02H
    INT 21H
    LOOP L2
    
    MOV AH,4CH
    INT 21H
    main endp
code ends
    end main
