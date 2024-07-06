.global _start
_start:

    movl size, %ecx # ecx = size of array
    cmp $3,%ecx
    jle is_seconddegree_HW1
    xorl %esi,%esi # esi = index of var in array 
    leaq series, %rbx # rbx = address of the 
    movl (%rbx,%rsi,4),%r8d # r8d = first var
    incl %esi
    movl (%rbx,%rsi,4),%r9d # r9d = second var
    incl %esi
    movl (%rbx,%rsi,4),%r10d # r10d = third var
    incl %esi 

    # caclculate difference between the first two pairs 
    movl %r9d, %r11d 
    subl %r8d,%r11d # r11d = r9d - r8d
    movl %r10d, %r12d 
    subl %r9d, %r12d # r12d = r10d - r9d

    # calculate the difference for Arithmetic sequence
    movl %r12d, %ebp # ebp = will hold the difference for Arithmetic sequence of differences 
    subl %r11d, %ebp 

    # calculate the quotient for geometric sequence
    movl %r12d, %eax
    testl %r11d,%r11d
    jz check_differences_only_arithmetic_sequence_HW1
    cdq
    idivl %r11d
    movl %eax, %esp # esp = will hold the quotient for geometric sequence of differences 

check_differences_sequence_HW1:
    cmpl %esi, %ecx
    je is_seconddegree_HW1
    movl (%rbx,%rsi,4),%r11d # r11d = next var

    # calculate for Arithmetic sequence
    movl %r11d, %r14d # backup the current var 
    subl %r10d, %r11d # r11d = current - prev
    movl %r11d, %r15d # backup the current difference
    subl %r12d, %r11d # curr difference = curr difference - prev difference  
    cmpl %r11d, %ebp # check if the the difference is the same  
    jne check_differences_geometric_sequence_HW1

    incl %esi
    # calculate for geometric sequence
    movl %r15d, %eax 
    testl %r12d,%r12d
    jz check_differences_arithmetic_sequence_HW1
    cdq
    idivl %r12d
    cmpl %eax, %esp
    jne check_differences_only_arithmetic_sequence_HW1


    movl %r14d, %r10d # current will be prev next iteration 
    movl %r15d, %r12d # current difference will be prev difference next iteration
    jmp check_differences_sequence_HW1

check_differences_geometric_sequence_HW1:
    
    # calculate for geometric sequence
    movl %r15d, %eax 
    testl %r12d, %r12d
    jz check_quotients_sequence_HW1
    cdq
    idivl %r12d
    cmpl %eax, %esp
    jne check_quotients_sequence_HW1

    # backup for next iteration 
    movl %r14d, %r10d # current will be prev next iteration 
    movl %r15d, %r12d # current difference will be prev difference next iteration

    incl %esi
    cmpl %esi, %ecx
    je is_seconddegree_HW1
    movl (%rbx,%rsi,4),%r11d # r11d = next var
    movl %r11d, %r14d # backup the current var 
    subl %r10d, %r11d # r11d = current - prev
    movl %r11d, %r15d # backup the current difference
    jmp check_differences_geometric_sequence_HW1

# if we jumped to this lable we have no geometric sequence due to a dividor being 0
check_differences_only_arithmetic_sequence_HW1:
    movl %r14d, %r10d # current will be prev next iteration 
    movl %r15d, %r12d # current difference will be prev difference next iteration
    cmpl %esi, %ecx
    je is_seconddegree_HW1
    movl (%rbx,%rsi,4),%r11d # r11d = next var

    # calculate for Arithmetic sequence
    movl %r11d, %r14d # backup the current var 
    subl %r10d, %r11d # r11d = current - prev
    movl %r11d, %r15d # backup the current difference
    subl %r12d, %r11d # curr difference = curr difference - prev difference  
    cmpl %r11d, %ebp # check if the the difference is the same  
    jne check_quotients_sequence_HW1
    incl %esi
check_differences_arithmetic_sequence_HW1:
    # backup for next iteration 
    movl %r14d, %r10d # current will be prev next iteration 
    movl %r15d, %r12d # current difference will be prev difference next iteration

    cmpl %esi, %ecx
    je is_seconddegree_HW1
    movl (%rbx,%rsi,4),%r11d # r11d = next var

    # calculate for Arithmetic sequence
    movl %r11d, %r14d # backup the current var 
    subl %r10d, %r11d # r11d = current - prev
    movl %r11d, %r15d # backup the current difference
    subl %r12d, %r11d # curr difference = curr difference - prev difference  
    cmpl %r11d, %ebp # check if the the difference is the same  
    jne check_quotients_sequence_HW1
    incl %esi
    jmp check_differences_arithmetic_sequence_HW1

check_quotients_sequence_HW1:
    xorl %esi,%esi # esi = index of var in array 
    movl (%rbx,%rsi,4),%r8d # r8d = first var
    incl %esi
    movl (%rbx,%rsi,4),%r9d # r9d = second var
    incl %esi
    movl (%rbx,%rsi,4),%r10d # r10d = third var
    incl %esi

    # caclculate quotient between the first two pairs 
    movl %r9d, %eax 
    testl %r8d,%r8d
    jz is_not_seconddegree_HW1
    cdq
    idivl %r8d # eax = r9d / r8d
    movl %eax, %r11d # r11d = r9d / r8d
    movl %r10d, %eax 
    testl %r9d,%r9d
    jz is_not_seconddegree_HW1
    cdq
    idivl %r9d # eax = r10d / r9d
    movl %eax, %r12d # r12d = r10d / r9d

    # calculate differences (arithmetic sequence) of quotient pairs
    movl %r12d, %r8d
    subl %r11d, %r12d # r12d = quotient of second pair - quotient of first pair
    movl %r12d, %ebp # ebp holds difference for aritmetic sequence 

    # calculate quotient (geometric sequence) of quotient pairs 
    testl %r11d,%r11d
    jz check_quotient_only_arithmetic_sequence_HW1
    cdq
    idivl %r11d # eax = r12d / r11d
    movl %eax, %esp # esp holds quotient for geometric sequence
    movl %r8d, %r12d # r12d = r10d / r9d, r10d = curr last 

check_quotients_sequence_loop_HW1:
    cmpl %esi, %ecx
    je is_seconddegree_HW1
    movl (%rbx,%rsi,4),%r11d # r11d = next var

    # calculate for Arithmetic sequence
    movl %r11d, %eax 
    testl %r10d,%r10d
    jz is_not_seconddegree_HW1
    cdq
    idivl %r10d # eax = current / prev
    movl %eax, %r15d # backup new quotient

    subl %r12d, %eax # curr difference = curr quotient - prev quotient  
    cmpl %eax, %ebp # check if the the difference is the same  
    jne check_quotient_geometric_sequence_HW1

    incl %esi
    # calculate for geometric sequence
    movl %r15d, %eax 
    testl %r12d,%r12d
    jz check_quotient_arithmetic_sequence_HW1
    cdq
    idivl %r12d # eax is new quotient of quotients, new quotient / last quotient
    cmpl %eax, %esp # eax is new quotient of quotients 
    jne check_quotient_arithmetic_sequence_HW1
    movl %r11d, %r10d # current will be prev next iteration 
    movl %r15d, %r12d # current quotient will be prev quotient next iteration
    jmp check_quotients_sequence_loop_HW1

check_quotient_geometric_sequence_HW1:
    # calculate for geometric sequence
    movl %r15d, %eax 
    testl %r12d,%r12d
    jz is_not_seconddegree_HW1
    cdq
    idivl %r12d
    cmpl %eax, %esp
    jne is_not_seconddegree_HW1

    # backup for next iteration 
    movl %r11d, %r10d # current will be prev next iteration 
    movl %r15d, %r12d # current difference will be prev difference next iteration

    incl %esi
    cmpl %esi, %ecx
    je is_seconddegree_HW1
    movl (%rbx,%rsi,4),%r11d # r11d = next var
    movl %r11d, %eax 
    testl %r10d,%r10d
    jz is_not_seconddegree_HW1
    cdq
    idivl %r10d # eax = current / prev
    movl %eax, %r15d # backup new quotient
    jmp check_quotient_geometric_sequence_HW1
check_quotient_only_arithmetic_sequence_HW1:
    movl %r8d, %r12d # r12d = r10d / r9d, r10d = curr last 
    cmpl %esi, %ecx
    je is_seconddegree_HW1
    movl (%rbx,%rsi,4),%r11d # r11d = next var

    # calculate for Arithmetic sequence
    movl %r11d, %eax 
    testl %r10d,%r10d
    jz is_not_seconddegree_HW1
    cdq
    idivl %r10d # eax = current / prev
    movl %eax, %r15d # backup new quotient

    subl %r12d, %eax # curr difference = curr quotient - prev quotient  
    cmpl %eax, %ebp # check if the the difference is the same  
    jne is_not_seconddegree_HW1

    incl %esi

check_quotient_arithmetic_sequence_HW1:
    # backup for next iteration 
    movl %r11d, %r10d # current will be prev next iteration 
    movl %r15d, %r12d # current quotient will be prev quotient next iteration

    cmpl %esi, %ecx
    je is_seconddegree_HW1
    movl (%rbx,%rsi,4),%r11d # r11d = next var

    # calculate for Arithmetic sequence
    movl %r11d, %eax 
    testl %r10d,%r10d
    jz is_not_seconddegree_HW1
    cdq
    idivl %r10d # eax = current / prev
    movl %eax, %r15d # backup new quotient

    subl %r12d, %eax # curr difference = curr quotient - prev quotient  
    cmpl %eax, %ebp # check if the the difference is the same  
    jne is_not_seconddegree_HW1
    incl %esi
    jmp check_differences_arithmetic_sequence_HW1

is_not_seconddegree_HW1:
    movb $0, seconddegree
    jmp end_HW1

is_seconddegree_HW1:
    movb $1, seconddegree

end_HW1:
