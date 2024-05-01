section .asm

extern int21h_handler
extern no_interrupt_handler

global int21h
global idt_load
global no_interrupt

idt_load:
    push ebp ; Shifting stack frame
    mov ebp, esp

    mov ebx, [ebp+8] ; Calling lidt with parameter address from previous frame
    lidt [ebx]

    pop ebp
    ret

int21h: ; Need to stop interrupts and iret whenever int21 is called
    cli
    pushad
    call int21h_handler
    popad
    sti
    iret

no_interrupt:
    cli
    pushad
    call no_interrupt_handler
    popad
    sti
    iret
