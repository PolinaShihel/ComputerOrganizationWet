.global _start

.section .text
_start:
    movl $1, %edx # edx = counter of nodes
    movl $0, %ecx # ecx = counter of leaves 
    xorq %r8,%r8 # initiating index of first level
    xorq %r9,%r9 # initiating index of second level
    xorq %r10,%r10 # initiating index of third level
    xorq %r11,%r11 # initiating index of forth level
    xorq %r12,%r12 # initiating index of fifth level
    xorq %r13,%r13 # initiating index of sixth level
    leaq root, %rsi
first_level_HW1:
    movq (%rsi,%r8,8), %rdi # rdi = current node of first level
    testq %rdi,%rdi # check if no more nodes in level
    jnz not_last_first_HW1
    testq %r8,%r8 # check if the label of this level is a leaf (root)
    jnz end__traverse_HW1
    incl %ecx
    jmp end__traverse_HW1
not_last_first_HW1:
    incl edx
    incq %r8
    xorq %r9,%r9 # index of loop 


second_level_HW1:
    movq (%rdi,%r9,8), %rax # rax = current node of second level
    testq %rax,%rax # check if no more nodes in level
    jnz not_last_second_HW1
    testq %r9,%r9 # check if the label of this level is a leaf
    jnz first_level_HW1
    incl %ecx
    jmp first_level_HW1
not_last_second_HW1:
    incl edx
    incq %r9
    xorq %r10,%r10 # index of loop 

third_level_HW1:
    movq (%rax,%r10,8), %rbx # rbx = current node of third level
    testq %rbx,%rbx # check if no more nodes in level 
    jnz not_last_third_HW1
    testq %r10,%r10 # check if the label of this level is a leaf
    jnz second_level_HW1
    incl %ecx
    jmp second_level_HW1
not_last_third_HW1:
    incl edx
    incq %r10
    xorq %r11,%r11 # index of loop 

forth_level_HW1:
    movq (%rbx,%r11,8), %r14 # r14 = current node of forth level
    testq %r14,%r14 # check if no more nodes in level 
    jnz not_last_forth_HW1
    testq %r11,%r11 # check if the label of this level is a leaf 
    jnz third_level_HW1
    incl %ecx
    jmp third_level_HW1
not_last_forth_HW1:
    incl edx
    incq %r11
    xorq %r12,%r12 # index of loop 
fifth_level_HW1:
    movq (%r14 ,%r12,8), %rbp # rbp = current node of fifth level
    testq %rbp,%rbp # check if no more nodes in level 
    jnz not_last_fifth_HW1
    testq %r12,%r12 # check if the label of this level is a leaf 
    jnz forth_level_HW1
    incl %ecx
    jmp forth_level_HW1
not_last_fifth_HW1:
    incl edx
    incq %r12
    xorq %r13,%r13 # index of loop 
sixth_level_HW1:
    movq (%rbp,%r13,8), %rsp # rsp = current node of sixth level
    testq %rsp,%rsp # check if no more nodes in level
    jnz not_last_sixth_HW1
    testq %r13,%r13 # check if the label of this level is a leaf
    jnz fifth_level_HW1
    incl %ecx 
    jmp fifth_level_HW1
not_last_sixth_HW1:
    incl edx
    incq %r13
    jmp sixth_level_HW1
end__traverse_HW1:
    movq %edx,%eax
    divl %ecx
    cmpl $3, %eax
    jle is_rich_HW1
    movb $0, rich
    jmp end_HW1
is_rich_HW1:
    movb $1, rich
end_HW1:


