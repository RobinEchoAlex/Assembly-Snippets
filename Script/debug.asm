;insect code below to main procedure
;replace reg with target register
	PUSH REG
	PUSH AX
	MOV DL,REG
	MOV AH,2
	INT 21H
	POP AX
	POP REG	
;end

;debug sub procedure    
printn proc						
	PUSH AX
	PUSH DX
	ADD DL,30H			
	MOV AH,2
	INT 21H
	POP DX
	POP AX
	ret
printn endp
;end

