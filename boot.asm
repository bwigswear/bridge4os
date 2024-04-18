ORG 0
BITS 16 
_start: ;Bios Parameter Block
    jmp short start
    nop

 times 33 db 0 ;Fill 33 bytes with 0 to complete BPB

start:
    jmp 0x7c0:step2

step2: 
    cli ; Clear Interrupts
    mov ax, 0x7c0 ; Can't move values directly into segments for whatever reason
    mov ds, ax
    mov es, ax
    mov ax, 0x00
    mov ss, ax
    mov sp, 0x7c00
    sti ; Enables Interrupts

    mov ah, 2
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov bx, buffer
    int 0x13 ; Loads subsequent sector, make file is used to append sector with message
    jc error


    mov si, buffer
    call print
    jmp $

error:
    mov si, error_message
    call print

    jmp $ 

print: ;Prints one char from essage as a time, once done, returns
    mov bx, 0
.loop:
    lodsb ;Moves char of string pointed to by SI and increments SI
    cmp al, 0
    je .done
    call print_char
    jmp .loop
.done:
    ret

print_char:
    mov ah, 0eh 
    int 0x10
    ret


error_message: db 'Failed to load sector', 0

times 510-($ - $$) db 0 
dw 0xAA55 

buffer: ; This is to be able to reference the sector after the bootloader