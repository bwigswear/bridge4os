ORG 0x7c00
BITS 16 

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

_start: ;Bios Parameter Block
    jmp short start
    nop

 times 33 db 0 ;Fill 33 bytes with 0 to complete BPB

start:
    jmp 0:step2

step2: 
    cli ; Clear Interrupts
    mov ax, 0x00 ; Can't move values directly into segments for whatever reason
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    sti ; Enables Interrupts

.load_protected:
    cli
    lgdt[gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp CODE_SEG:load32
    jmp $


; GDT
gdt_start:
gdt_null:
    dd 0x0
    dd 0x0

; offset 0x8
gdt_code: 
    dw 0xffff ; Segment limit first 0-15 bits
    dw 0 ; Base first 015 bits
    db 0 ; Base 16-23 bits
    db 0x9a ; Access byte
    db 11001111b ; High and low 5 bit flags
    db 0 ; Base 24-31 bits
; offset 0x10
gdt_data:
    dw 0xffff ; Segment limit first 0-15 bits
    dw 0 ; Base first 015 bits
    db 0 ; Base 16-23 bits
    db 0x92 ; Access byte
    db 11001111b ; High and low 5 bit flags
    db 0 ; Base 24-31 bits

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; Size of the descriptro
    dd gdt_start

[BITS 32]
load32:
    mov eax, 1 ; want to load from sector 1
    mov ecx, 100 ; want to load 100 sectors
    mov edi, 0x0100000 ; address to load into
    call ata_lba_read
    jmp CODE_SEG:0x0100000

ata_lba_read:
    mov ebx, eax
    shr eax, 24 ; Shift 24 bits to the right
    or eax, 0xE0 ; Select the master drive
    mov dx, 0x1F6 ; Port to write bits to
    out dx, al ; Talking to the I/O bus

    ; Send the total sectors to read
    mov eax, ecx
    mov dx, 0x1F2
    out dx, al

    mov eax, ebx ; Restore eax
    mov dx, 0x1F3
    out dx, al

    mov dx, 0x1F4
    mov eax, ebx
    shr eax, 8
    out dx, al

    mov dx, 0x1F5
    mov eax, ebx
    shr eax, 16
    out dx, al
    ; Finished sending bits of LBA

    mov dx, 0x1f7
    mov al, 0x20
    out dx, al

.next_sector: ; Read all sectors in to memory
    push ecx

.try_again: ; Check if we need to read
    mov dx, 0x1f7 ; Read from port 0x1f7 into al
    in al, dx
    test al, 8
    jz .try_again

    ; Read 256 words at a time
    mov ecx, 256
    mov dx, 0x1F0
    rep insw ; Reading from port in dx and storing in mem address in edi, repeats ecx=256 times
    pop ecx
    loop .next_sector
    ; End of reading sectors
    ret


times 510-($ - $$) db 0 
dw 0xAA55 
