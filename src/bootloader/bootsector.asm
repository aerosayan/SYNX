;------------------------------------------------------------------------------
;
; @file   : bootsector.asm
; @info   : Creates and loads the kernel bootsector.
; @author : Sayan Bhattacharjee
; @email  : aero.sayan@gmail.com
; @date   : 21-JULY-2019
;
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; Set a global offset to ensure the code knows it's loaded at 0x7c00.
; 0x7c00 is the memory location where a bootsector is always loaded,
; however the binary doesn't know that so we add this global offset.
;
; Without using the global offset, we would have to add 0x7c00 to every
; memory offset/pointer that we would like to access/print.
;------------------------------------------------------------------------------
[org 0x7c00]

;------------------------------------------------------------------------------
; Setup stack.
;
; It is necessary to setup the stack at a far away distance from our
; critical code in bootsector located at 0x7c00 to prevent it from getting
; overwritten by the downward growing stack.
;
; The base pointer (bp) and stack pointer (sp) is initialized at 0x8000.
; The base pointer will stay at the initialized position, however the
; stack pointer will grow downwards as we push elements into it.
;
; NOTE : Each element of the stack occupies full 16 bit, thus even if we
; insert a single byte (say a character) the full 16 bit will be occupied
; by the newly pushed element at the top of the stack.
;------------------------------------------------------------------------------
mov bp, 0x8000
mov sp, bp

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

push 'A'
push 'B'
push 'C'

mov al, [0x7ffe]
int 0x10

mov al, [0x7ffc]
int 0x10

mov al, [0x7ffa]
int 0x10

pop bx                   ; Full word has to be extracted from stack
mov al, bl               ; Then the desired byte can be accessed
int 0x10

pop bx
mov al, bl
int 0x10

pop bx
mov al, bl
int 0x10


jmp $                    ; Infinite jump loop to current address

;------------------------------------------------------------------------------
; Insert padding and magic number
;------------------------------------------------------------------------------
; Fill with (510-size of previous code) zeroes
times 510 - ($-$$) db 0

; Insert magic number
dw 0xaa55
