ORG 0x7c00 ;Memory address where boot loader code is usually loaded by BIOS
BITS 16 ;Operating in 16 bit code

start:
    mov ah, 0eh ;Saves function to be performed by later line
    mov al, 'A' ;Saves output for previous functions
    mov bx, 0 ;Not sure purpose of this
    int 0x10 ;Video services interrupt, uses AH reg to figure out what function to call

    jmp $ ;Prevent execution of signature, infinite loop

times 510-($ - $$) db 0 ;Tells program to fill 510 bytes to meet disk sector quota
;$ = current location, $$ beginning of the section
dw 0xAA55 ;Intel is little-endian, boot signature us 55AA