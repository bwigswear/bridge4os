section .asm

global idt_load
idt_load:
    push ebp ; Shifting stack frame
    mov ebp, esp

    mov ebx, [ebp+8] ; Calling lidt with parameter address from previous frame
    lidt [ebx]

    pop ebp
    ret