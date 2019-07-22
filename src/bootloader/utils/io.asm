;------------------------------------------------------------------------------
;
; @file   : io.asm
; @info   : Utilities for IO opeartions to be used by the bootloader
; @author : Sayan Bhattacharjee
; @email  : aero.sayan@gmail.com
; @date   : 22-JULY-2019
;
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; Print a string and start a new line.
;------------------------------------------------------------------------------
; Registers:
; [in] bx : The pointer to the null terminated string to be printed.
;------------------------------------------------------------------------------
echo:
  ;----------------------------------------------------------------------------
  ; Setup the required registers.
  ;----------------------------------------------------------------------------
  pusha                            ; All registers are pushed to stack.

echo_loop:
  mov al, [bx]                     ; bx is the pointer to the current character
                                   ; of the string being printed.

  cmp al, 0                        ; The string is null terminated.
  je return_nl                     ; If end of string is found,function returns

  ;----------------------------------------------------------------------------
  ; Print each character of the string.
  ;----------------------------------------------------------------------------
  ; Activate tty mode my setting 'ah' to '0x0e' and then move each particular
  ; character to 'al' and calling interrupt 0x10 to print them on screen.
  ;
  ; NOTE : The character to be printed has already been stored in al.
  ; So, the only thing required to do is to setup the tty mode to ensure that
  ; the Interrupt Vector Table (IVT) is setup properly to be able to
  ; call the Interrupt Service Routine (ISR) to print to screen.
  ;----------------------------------------------------------------------------
  mov ah, 0x0e
  int 0x10

  add bx, 1                        ; The pointer bx is incremented to
                                   ; essentially point to the next character
                                   ; in the string.

  jmp echo_loop                    ; Jump to the front of the print loop


; Function returns after printing a newline
return_nl:
  call print_nl
  popa
  ret

; Print a newline and move cursor to next line
print_nl:
  pusha
  mov ah, 0x0e                      ; start tty mode
  mov al, 0x0a                      ; newline character
  int 0x10
  mov al, 0x0d                      ; carraige return
  int 0x10
  popa
  ret

