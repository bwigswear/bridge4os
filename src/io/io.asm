section .asm

global insb
global insw
global outb
global outw

insb:
    push ebp
    mov ebp, esp

    xor eax, eax ; Set to 0
    mov edx, [ebp+8] ; Mov param to edx
    in al, dx ; Call in on port taken from lower bits of edx, store in al
    ; al is lower 8 bits of eax, which is default return value


    pop ebp
    ret

insw:
    push ebp
    mov ebp, esp

    xor eax, eax
    mov edx, [ebp+8] 
    in ax, dx


    pop ebp
    ret

outb: 
    push ebp
    mov ebp, esp

    mov eax, [ebp+12]
    mov edx, [ebp+8]
    out dx, al


    pop ebp
    ret

outw: 
    push ebp
    mov ebp, esp

    mov eax, [ebp+12]
    mov edx, [ebp+8]
    out dx, ax


    pop ebp
    ret