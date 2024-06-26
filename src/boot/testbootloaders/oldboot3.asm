ORG 0
BITS 16 
_start: ;Bios Parameter Block
    jmp short start
    nop

 times 33 db 0 ;Fill 33 bytes with 0 to complete BPB

start:
    jmp 0x7c0:step2

handle_zero:
    mov ah, 0eh
    mov al, 'A'
    mov bx, 0x00
    int 0x10
    iret

handle_one:
    mov ah, 0eh
    mov al, 'V'
    mov bx, 0x00
    int 0x10
    iret

step2: 
    cli ; Clear Interrupts
    mov ax, 0x7c0 ; Can't move values directly into segments for whatever reason
    mov ds, ax
    mov es, ax
    mov ax, 0x00
    mov ss, ax
    mov sp, 0x7c00
    sti ; Enables Interrupts

    mov word[ss:0x00], handle_zero
    mov word[ss:0x02], 0x7c0

    mov word[ss:0x04], handle_one
    mov word[ss:0x06], 0x7c0

    mov ax, 0x00
    div ax

    mov si, message
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

message: db 'Hello World!', 0

times 510-($ - $$) db 0 
dw 0xAA55 