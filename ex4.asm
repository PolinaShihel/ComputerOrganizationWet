.global _start

.section .data # TODO:DELETE THIS
Node1: 
	.quad 0
	.int 1
	.quad Node2
Node2: 
	.quad Node1
	.int 4
	.quad Node3
Node3: 
	.quad Node2
	.int 7
	.quad Node4
Node4: 
	.quad Node3
	.int 5
	.quad Node5
Node5: 
	.quad Node4
	.int 9
	.quad Node6
Node6: 
	.quad Node5
	.int 8
	.quad Node7
Node7: 
	.quad Node6
	.int 7
	.quad Node8
Node8: 
	.quad Node7
	.int 6
	.quad 0
nodes: Node4, Node6, Node3
result: .byte 0

.section .text
_start:
    leaq nodes, %rsi 
    xorl %ecx,%ecx
loop_through_array_HW1:
    movq (%rsi), %rdi
    movl $1, %ebp # ebp will hold true/flase for existance of sequence, start as true  
    # xorl %esp, %esp # esp = flag that indicates if descending or ascending
    movq 0(%rdi), %rbx # rbx = previous node
    cmpq $0, %rbx # checks if current is the first node
    jz check_after_sequence_HW1
check_before_sequence_HW1:
    movl 8(%rbx), %eax # eax = value of current node 
    movq 0(%rbx), %rsp # rsp = previous node
    movl 8(%rsp), %edx # edx = value of prev node
    cmpl %eax, %edx
    jg check_before_descending_HW1
    jl check_before_ascending_HW1 # id not bigger or smaller is equal and the sequence is general
    movq %rsp, %rbx # rbx will now point to the next prev node 
    movq 0(%rbx), %rsp # rsp = previous node
    cmpq $0, %rsp # checks if current is the first node
    jz check_after_sequence_HW1
    jmp check_before_sequence_HW1
check_before_descending_HW1:
    movq %rsp, %rbx # rbx will now point to the next prev node and will now be the current
    movq %edx, %eax # eax = value of current node 
    movq 0(%rbx), %rsp # rsp = previous node
    cmpq $0, %rsp # checks if curr is the first node
    jz check_after_sequence_HW1
    movl 8(%rsp), %edx # edx = value of prev node
    cmpl %eax, %edx
    jge check_before_ascending_HW1
    movl $0, %ebp # the sequence is broken and no need to check further
    jmp finished_checking_HW1
check_before_ascending_HW1:
    movq %rsp, %rbx # rbx will now point to the next prev node and will now be the current
    movq %edx, %eax # eax = value of current node 
    movq 0(%rbx), %rsp # rsp = previous node
    cmpq $0, %rsp # checks if curr is the first node
    jz check_after_sequence_HW1
    movl 8(%rsp), %edx # edx = value of prev node
    cmpl %eax, %edx
    jle check_before_ascending_HW1
    movl $0, %ebp # the sequence is broken and no need to check further
    jmp finished_checking_HW1
check_after_sequence_HW1:
    movq 12(%rdi), %rsp # rsp = next node
    cmpq $0, %rsp # checks if curr is the last node
    jz finished_checking_HW1
    movl 8(%rdi), %eax # eax = value of current node 
    movl 8(%rsp), %edx # edx = value of next node
    cmpl %eax, %edx
    jg check_after_ascending_HW1
    jl check_after_descending_HW1 # id not bigger or smaller is equal and the sequence is general
    movq %rsp, %rdi # rdi will now point to the next node 
    jmp check_after_sequence_HW1
check_after_descending_HW1:
    movq %rsp, %rdi # rdi will now point to the next node and will now be the current
    movq %edx, %eax # eax = value of current node 
    movq 12(%rdi), %rsp # rsp = next node
    cmpq $0, %rsp # checks if curr is the last node
    jz finished_checking_HW1
    movl 8(%rsp), %edx # edx = value of next node
    cmpl %eax, %edx
    jle check_after_descending_HW1
    movl $0, %ebp # the sequence is broken and no need to check further
    jmp finished_checking_HW1
check_after_ascending_HW1:
    movq %rsp, %rdi # rdi will now point to the next node and will now be the current
    movq %edx, %eax # eax = value of current node 
    movq 12(%rdi), %rsp # rsp = next node
    cmpq $0, %rsp # checks if curr is the last node
    jz finished_checking_HW1
    movl 8(%rsp), %edx # edx = value of next node
    cmpl %eax, %edx
    jge check_after_ascending_HW1
    movl $0, %ebp # the sequence is broken and no need to check further
finished_checking_HW1:
    cmpl $1, %ebp
    jne end_loop_HW1
    addb $1, result
end_loop_HW1:
    cmp $3, %ecx
    je end_HW1
    inc %ecx
    addq $8,%rsi #go to the next in nodes array
    jmp loop_through_array_HW1

end_HW1:




    
    