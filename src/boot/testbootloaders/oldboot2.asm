ORG 0x7c00
BITS 16 

start:
    move si, message
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