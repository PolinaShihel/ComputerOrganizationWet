.global _start
.section .text
_start:
    movl size, %ecx # ecx = size of array
    leaq series, %rbx # rbx = address of the 