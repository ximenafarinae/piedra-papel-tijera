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
	PLEQ    db 'Player 1 = Player 2 $', 0
	nroRandom dw 0DH, 0AH,24H
	nroImp dw 0DH, 0AH,24H
.code 
	extrn random:proc
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
		   mov cx, offset nroRandom
		   push cx
		   CALL random

		   mov ah,9
	       mov dx, offset nroRandom
	       int 21h

	       MOV AH,4Ch            	; Function to exit
	       MOV AL,00             	; Return 00
	       INT 21h
    
	main ENDP  

	
	    
end main