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
; Print kernel info.
;------------------------------------------------------------------------------
mov bx, KERNEL_NAME
call echo

mov bx, AUTHOR_NAME
call echo

mov bx, AUTHOR_EMAIL
call echo

mov dx, 0x1234
call echo_hex

mov dx, 0xb008
call echo_hex

mov dx, 0xdeb6
call echo_hex

jmp $                    ; Infinite jump loop to current address

;------------------------------------------------------------------------------
; Include files.
; NOTE : It's important to keep the included files below the infinite loop
;------------------------------------------------------------------------------
%include 'utils/io.asm'

; Data
KERNEL_NAME:
  db 'KERNEL > SYNX v0.0.1', 0

AUTHOR_NAME:
  db 'AUTHOR > Sayan Bhattacharjee' , 0

AUTHOR_EMAIL:
  db 'EMAIL  > aero.sayan@gmail.com' ,0

;------------------------------------------------------------------------------
; Insert padding and magic number
;------------------------------------------------------------------------------
; Fill with (510-size of previous code) zeroes
times 510 - ($-$$) db 0

; Insert magic number
dw 0xaa55
