.8086
.model small
.stack 100h
.data
.code

    public random
    public CalcNew

;GENERA UN NUMERO ALEATORIO QUE VA A SER EL VALOR QUE ELIGE LA MAQUINA PARA JUGAR.
random PROC
    push bp
    mov bp, sp
    mov bx, ss:[bp+2]

    MOV     AH, 00h   ; interrupt to get system timer in CX:DX 
    INT     1AH
    mov     bx, dx
    call    CalcNew   ; -> AX is a random number
    xor     dx, dx
    mov     cx, 10    
    div     cx        ; here dx contains the remainder - from 0 to 9
    add     dl, '0'   ; to ascii from '0' to '9'
    mov     ah, 02h   ; call interrupt to display a value in DL
    int     21h    
    call    CalcNew   ; -> AX is another random number
	RET 2
random ENDP 
; ----------------
; inputs: none  (modifies PRN seed variable)TAS
; clobbers: DX.  returns: AX = next random number
CalcNew PROC
    mov     ax, 25173          ; LCG Multiplier
    mul     bx     ; DX:AX = LCG multiplier * seed
    add     ax, 13849          ; Add LCG increment value
    ; Modulo 65536, AX = (multiplier*seed+increment) mod 65536
    mov     bx, ax          ; Update seed = return value
    SHR     AX, 5
    ret 
CalcNew ENDP  


end