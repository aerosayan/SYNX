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
  je echo_return                   ; If end of string is found,function returns

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
echo_return:
  call echo_nl
  popa
  ret


;------------------------------------------------------------------------------
; Print hexadecimal
;------------------------------------------------------------------------------
; Registers:
; [in] dx : The hexadecimal to be printed.
;         : Assume, dx has value 0x1234
;------------------------------------------------------------------------------
; Hex   :   0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
; ASCII : 30h 31h 32h 33h 34h 35h 36h 37h 38h 39h 41h 42h 43h 44h 45h 46h
;------------------------------------------------------------------------------
; It is important to note that in the ascii representation, after 39h we
; have 3Ah; but the hex characters A correspond to 41h.
; Thus, there is a gap between 39h and 40h that is filled with ascii characters.
;------------------------------------------------------------------------------
echo_hex:
  pusha
  mov cx, 0                          ; Loop counter

echo_hex_loop:
  cmp cx, 4                          ; End loop after 4 iterations
  je echo_hex_return

  ; get the last digit using bitmask 0x000f
  mov ax, dx
  and ax, 0x000f

  ; Determine if current element is a digit[0-9] or alphabet[A-B]
  cmp al, 9
  jg echo_hex_alpha

  ; Observed numeric digit [0-9] : add 0x30 to convert to ascii
echo_hex_num:

  add al,0x30
  jmp echo_hex_alphanum_done

  ; Observed alphabet [A-F] : sub 9 then add 0x40 to convert to ascii
echo_hex_alpha:

  sub al, 9
  add al,0x40
  jmp echo_hex_alphanum_done

  ; end of if-else branch
echo_hex_alphanum_done:

  ; Insert the ascii value into the string
  mov bx, HEX2ASCII + 5              ; Jump to end of string
  sub bx, cx                         ; Jump to the current digit position
  mov [bx], al                       ; Set the character in the string
  ror dx, 4                          ; Rotate dx to right by 4 bits i.e a digit
  add cx, 1                          ; Increment count of digits processed

  jmp echo_hex_loop

; Return to caller after printing ascii form of the hex
echo_hex_return:
  mov bx, HEX2ASCII
  call echo
  popa
  ret

;------------------------------------------------------------------------------
; Print a newline and move cursor to next line
;------------------------------------------------------------------------------
echo_nl:
  pusha
  mov ah, 0x0e                      ; start tty mode
  mov al, 0x0a                      ; newline character
  int 0x10
  mov al, 0x0d                      ; carraige return
  int 0x10
  popa
  ret

;------------------------------------------------------------------------------
; Data variables
;------------------------------------------------------------------------------
HEX2ASCII:                           ; Variable to use in echo_hex
  db '0xb008',0                      ; ASCII form of the hex to be printed
