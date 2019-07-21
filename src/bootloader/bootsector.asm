;------------------------------------------------------------------------------
; Activate tty mode my setting 'ah' to '0x0e' and then move each particular
; character to 'al' and calling interrupt 0x10 to print them on screen.
;------------------------------------------------------------------------------
mov ah, 0x0e             ; Activate tty mode
mov al, 'H'              ; Character to print
int 0x10                 ; Print to screen
mov al, 'e'
int 0x10
mov al, 'l'
int 0x10
int 0x10
mov al, 'o'
int 0x10



jmp $                    ; Infinite jump loop to current address

;------------------------------------------------------------------------------
; Insert padding and magic number
;------------------------------------------------------------------------------
; Fill with (510-size of previous code) zeroes
times 510 - ($-$$) db 0

; Insert magic number
dw 0xaa55
