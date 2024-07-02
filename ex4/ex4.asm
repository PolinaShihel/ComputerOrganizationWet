.global _start

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

# Print "result="
    movq $1, %rax            # syscall number for sys_write
    movq $1, %rdi            # file descriptor (stdout)
    lea result_label(%rip), %rsi   # address of result_label
    movq $8, %rdx            # number of bytes to write (length of "result=")
    syscall                  # make the syscall to print "result="

    # Convert result to ASCII character
    movzbq result, %rax      # zero-extend result into %rax
    add $'0', %al            # convert result value to ASCII character
    movb %al, result_buf     # move ASCII character to result_buf

    # Print the value of 'result'
    movq $1, %rax            # syscall number for sys_write
    movq $1, %rdi            # file descriptor (stdout)
    lea result_buf(%rip), %rsi   # address of result_buf
    movq $1, %rdx            # number of bytes to write (1 byte for result value)
    syscall                  # make the syscall to print result

    # Print a newline
    movq $1, %rax            # syscall number for sys_write
    movq $1, %rdi            # file descriptor (stdout)
    lea newline(%rip), %rsi  # address of newline character
    movq $1, %rdx            # number of bytes to write (1 byte for newline)
    syscall                  # make the syscall to print newline

    # Exit the program
    movq $60, %rax           # syscall number for sys_exit
    xor %rdi, %rdi           # exit status (0 for success)
    syscall                  # make the syscall to exit the program

.section .rodata
result_label:
    .asciz "result="
newline:
    .byte 10                 # ASCII code for newline ('\n')

.section .data
result_buf:
    .byte ' '                # initialize with a space character (' ')




    
    