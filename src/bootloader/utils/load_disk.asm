;------------------------------------------------------------------------------
;
; @file   : load_disk.asm
; @info   : Load data from disk
; @author : Sayan Bhattacharjee
; @email  : aero.sayan@gmail.com
; @date   : 28-JULY-2019
;
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; Load disk and read in sectors
;------------------------------------------------------------------------------
; Registers:
; [i] dh : Number of sectors to read
;------------------------------------------------------------------------------
load_disk:
  pusha
  push dx                          ; Save the requested number of sectors to
                                   ; be read and later compare with AL to
                                   ; verify if the requested number of sectors
                                   ; are correctly read

  mov ah, 2                        ; AH : Load instruction
  mov al, dh                       ; AL : Number of sectors to read
  mov cl, 2                        ; CL : Sector to start reading from
  mov ch, 0                        ; CH : Cyllinder head
                                   ; DL : Drive number and set by qemu or bochs
  mov dh, 0                        ; DH : Head  number


  int 0x13                         ; Call BIOS interrupt to read disk
  jc load_disk_error               ; If carry bit is set for error

  pop dx                           ; Requested number of sectors to read
  cmp al,dh                        ; Compare with total number of sectors read
  jne load_disk_unread_sectors_error


  popa
  ret

; Error handling for error during execution of 0x13 interrrupt
load_disk_error:
  mov dx, 0xE001                   ; Error code
  call echo_hex
  jmp $

; Error handling for when the total requested number of sectors aren't read
load_disk_unread_sectors_error:
  mov dx, 0xE002                   ; Error code
  call echo_hex
  jmp $





