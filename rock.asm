.8086
.model SMALL
.stack 100h

.data
        
	CR      db 13,10,'$'
	MSG     db 'GAME Instruction: Rock=1, Paper= 2, Scissors= 3, $', 0
	PL1     db 'Player 1: $', 0
	PL2     db 'Player 2: $', 0
	PL1_Win db 'Player 1 is the winner! $', 0
	PL2_Win db 'Player 2 is the winner! $', 0
	PLEQ    db 'P2layer 1 = Player 2 $', 0
	NRORANDOM dw 0DH, 0AH,24H
	nroImp dw 0DH, 0AH,24H
.code 
         ;TO DO: HACER UN A FUNCION QUE GENERE UN NRO RANDOM Y QUE AL DIVIDIRLO POR 3 DEPENDIENDO DEL RESTO TOME LA OPCION DE PIEDRA, PAPEL O TIJERA
         ;PROBAR SI EL RANDOM SE PUEDE HACER CON PALABRAS.
         ;VER GRAFICOS (PIXEL-ASCII-TXT)
    
	main PROC
		   MOV AX, @data
	       MOV DS, AX
	       MOV ES, AX
        
	       MOV DX, OFFSET MSG    	; Game Instruction
	       MOV AH, 09h
	       INT 21h
        
	       MOV DX, OFFSET CR     	; print Carrier Return
	       MOV AH, 09h
	       INT 21h
        
	       MOV DX, OFFSET PL1    	; Prompt of player1
	       MOV AH, 09h
	       INT 21h
        
	       MOV AH,08             	; Function to read a char from keyboard (Input by Player1)
	       INT 21h               	; the char saved in AL
	       MOV AH,02             	; Function to display a char
	       MOV BL,AL             	; Copy a saved char in AL to BL
	       MOV DL,AL             	; Copy AL to DL to output it
	       INT 21h
        
	       MOV DX, OFFSET CR     	; print Carrier Return
	       MOV AH, 09h
	       INT 21h
        
	       MOV DX, OFFSET PL2    	; Prompt of player2
	       MOV AH, 09h
	       INT 21h
        
	       MOV AH,08             	; Function to read a char from keyboard (Input by Player2)
	       INT 21h               	; the char saved in AL
	       MOV AH,02             	; Function to display a char
	       MOV BH,AL             	; Copy a saved char in AL to BH
	       MOV DL,AL             	; Copy AL to DL to output it
	       INT 21h

	       MOV DX, OFFSET CR     	; print Carrier Return
	       MOV AH, 09h
	       INT 21h
        
	       CMP BL, BH
	       JE  EQUAL

		   

    ;  =============================================================================================
    ;||     ;LO QUE ELIGIO EL PLAYER 1 QUEDA GUARDADO EN BL, Y LO QUE ELIGIO EL PLAYER 2 EN BH      ||
    ;  ============================================================================================= 

	;=======================================
	       CMP BL, '1'  ;COMPARA LO QUE ESTA EN BL CON PIEDRA
	       JE  EQ1      ;SI ES IGUAL SALTA A EQ1
	       CMP BL, '2'  ;SI NO COMPARA CON PAPEL
	       JE  EQ2      ;SI ES IGUAL SALTA A EQ2
	       CMP BL, '3'  ;SI NO COMPARA CON TIJERA
	       JE  EQ3      ;SI ES IGUAL SALTA A EQ3
        
	EQ1:   
	       CMP BH, '2'  ;COMPARA LO QUE ESTA EN BH CON PAPEL
	       JE  P2_Win   ;SI ES IGUAL, SALTA A IMPRIMIR EL CARTEL DE QUE EL GANADOR ES EL PLAYER 2
	       CMP BH, '3'  ;SI NO COMPARA LO QUE ESTA EN BH CON TIJERA
	       JE  P1_Win   ;SI ES IGUAL SALTA A IMPRIMIR QUE EL GANADOR ES EL PLAYER 1

	EQ2:   
	       CMP BH, '1'  ;COMPARA LO QUE ESTA EN BH CON PIEDRA
	       JE  P1_Win   ;SI ES IGUAL SALTA A IMPRIMIR QUE EL GANADOR ES EL PLAYER 1
	       CMP BH, '3'  ;COMPARA LO QUE ESTA EN BH CON TIJERA
	       JE  P2_Win   ;SI ES IGUAL, SALTA A IMPRIMIR EL CARTEL DE QUE EL GANADOR ES EL PLAYER 2
 
	EQ3:   
	       CMP BH, '1'  ;COMPARA LO QUE ESTA EN BH CON PIEDRA
	       JE  P2_Win   ;SI ES IGUAL, SALTA A IMPRIMIR EL CARTEL DE QUE EL GANADOR ES EL PLAYER 2
	       CMP BH, '2'  ;COMPARA LO QUE ESTA EN BH CON PAPEL
	       JE  P1_Win   ;SI ES IGUAL SALTA A IMPRIMIR QUE EL GANADOR ES EL PLAYER 1

	;=======================================
   
	P1_Win:                      	;Player 1 is winner
	       MOV DX, OFFSET PL1_Win
	       MOV AH, 09h
	       INT 21h
	       JMP Final
      
	EQUAL:                       	;Player 1 == Player 2
	       MOV DX, OFFSET PLEQ
	       MOV AH, 09h
	       INT 21h
	       JMP Final
        
	P2_Win:                      	;Player 2 is winner
	       MOV DX, OFFSET PL2_Win
	       MOV AH, 09h
	       INT 21h
	       JMP Final
	;=======================================
   
	Final: 

		   CALL RANDOM

		   mov ah,9
	       mov dx, offset NRORANDOM
	       int 21h

	       MOV AH,4Ch            	; Function to exit
	       MOV AL,00             	; Return 00
	       INT 21h
    
	main ENDP  

	;GENERA UN NUMERO ALEATORIO QUE VA A SER EL VALOR QUE ELIGE LA MAQUINA PARA JUGAR.
	random PROC
		PUSH AX ;GUARDO LO QUE TENIA CADA REGISTRO EN EL STACK
		PUSH CX
		PUSH DX

		MOV AX, 00h ;GENERO LA INTERRUPCION PARA GUARDAR LA HORA DEL SISTEMA EN CX:DX
		INT 1AH

		MOV [NRORANDOM], DX
		call    NEWRANDOM   ; -> AX is a random number
		xor     dx, dx
		mov     cx, 10    
		div     cx        ; here dx contains the remainder - from 0 to 9
		add     dl, '0'   ; to ascii from '0' to '9'
		mov     ah, 02h   ; call interrupt to display a value in DL
		int     21h    
		call    NEWRANDOM   ; -> AX is another random number
		
		POP DX	;LIMPIO EL STACK
		POP CX
		POP AX

		RET 6
	random ENDP  

	;description
	NEWRANDOM PROC
		; ----------------
; inputs: none  (modifies PRN seed variable)
; clobbers: DX.  returns: AX = next random number

    mov     ax, 25173          ; LCG Multiplier
    mul     word ptr [NRORANDOM]     ; DX:AX = LCG multiplier * seed
    add     ax, 13849          ; Add LCG increment value
    ; Modulo 65536, AX = (multiplier*seed+increment) mod 65536
    mov     [NRORANDOM], ax          ; Update seed = return value
    ret
	NEWRANDOM ENDP
	    
end main