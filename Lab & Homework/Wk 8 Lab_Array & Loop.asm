DATAS SEGMENT
    ARRAY DW 1,1,3,5,5,7,3
    array_max DB $-ARRAY-2      ;point to the lastdigit
    OCCOURANCE DW 100 dup(?)    ;common mistake: forget to allowcate a array of space for occourance
    array_iterator DB 0
    occourance_iterator DB 0
    occourance_max DB 0
DATAS ENDS

STACKS SEGMENT
    ;
STACKS ENDS

;#develop infomation
;AX = a[i] DX=o[j] 
;apply immediatly save rule
CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
                                
    MOV BX,ARRAY                ;store the first digit into occurance list
    MOV OCCOURANCE,BX
    ADD array_iterator,2
         
LOOP_ARRAY:                     ;for any other number in array
    MOV BH,0                    ;BL = i
    MOV BL,array_iterator
                                
    MOV AX,ARRAY[BX]            ;AX = a[i]
LOOP_OCC:                       ;compare with all numbers in occourance
    MOV DH,0                                
    MOV DL,occourance_iterator  
    
    MOV SI,DX                   ;SI = j
    MOV DX,OCCOURANCE[SI]       ;DX = o[j]
    CMP AX,DX
    JZ  LOOP_OCC_FSH            ;if a[i]=o[j] means the number has occoured, break directly        
    ADD occourance_iterator,2   ;else
    MOV BL,occourance_max        
    MOV BH,occourance_iterator
    CMP BH,BL                   ;if(j<=o.size())
    JNA LOOP_OCC                ;continue inner loop
    ADD SI,2                    ;j+=2
    MOV occourance[SI],AX       ;else we find a new number
    ADD occourance_max,2    
LOOP_OCC_FSH:                   ;prepare for next outer loop/exit if all number are processed
    MOV occourance_iterator,0    
    ADD array_iterator,2
    MOV BL,array_max
    MOV BH,array_iterator
    CMP BH,BL                   ;if (i<=a.size())
    JNA LOOP_ARRAY              ;continue outer loop
LOOP_ARRAY_FSH:
LOAD_SUM:                       ;occ.count() = (occ_max +2)/2, remember the number is word type
    MOV BH,0
    MOV BL,occourance_max
    ADD BL,2
    SHR BL,1                    ;same as /2
PRINT:                          ;the question do not required output, just for debug conveniently
    MOV DL,BL
    ADD DL,30H
    MOV AH,2
    INT 21H        
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START










