#include "idt.h"
#include "../config.h"
#include "../kernel.h"
#include "../memory/memory.h"
struct idt_desc idt_descriptors[BRIDGE4OS_TOTAL_INTERRUPTS]; // idt entries
struct idtr_desc idtr_descriptor; // Metadata for idt

extern void idt_load(struct idtr_desc* ptr); // Assembly functioning for loading table into memory

void idt_zero(){ // First interrupt is divide by zero
    print("Divide by zero error\n");
}

void idt_set(int interrupt_no, void* address){ // Pass in designated idt number and function address to be placed there
    struct idt_desc* desc = &idt_descriptors[interrupt_no];
    desc->offset_1 = (uint32_t) address & 0x0000fffff;
    desc->selector = KERNEL_CODE_SELECTOR;
    desc->zero = 0x00;
    desc->type_attr = 0xEE;
    desc->offset_2 = (uint32_t) address >> 16;
}

void idt_init(){
    // Initialize idt with 0s, fill in metadata
    memset(idt_descriptors, 0, sizeof(idt_descriptors));
    idtr_descriptor.limit = sizeof(idt_descriptors) - 1;
    idtr_descriptor.base = (uint32_t) idt_descriptors;

    // Set first table interrupt
    idt_set(0, idt_zero);

    // Load table descriptor/metadata into memory
    idt_load(&idtr_descriptor);
}