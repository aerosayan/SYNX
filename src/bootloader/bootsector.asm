; Infinite jump loop
loop:
  jmp loop

; Write the bootsector
; Fill with (510-size of previous code) zeroes
times 510 - ($-$$) db 0

; Insert magic number
dw 0xaa55
