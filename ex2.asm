.global _start

_start:
	movq size, %rcx
	leaq data, %rsi
	movq %rcx,%r15
	subq $1, %r15
	movb (%rsi,%r15,1),%al #gets to the last char in data
	cmpb $0,%al # checks if the last char is a null terminator
	jne check_if_divides_by_8_HW1
	xorb %al, %al
	xorq %rdi, %rdi
check_if_simple_string_HW:
	movb (%rsi,%rdi,1),%al
	cmpb $32 ,%al # checks if space	
	je next_char_HW1
	cmpb $33 ,%al # checks if !
	je next_char_HW1
	cmpb $44 ,%al # checks if ,
	je next_char_HW1
	cmpb $46 ,%al # checks if .
	je next_char_HW1
	cmpb $48 ,%al # checks if lower than 0 - not a simple string
	jl continue_from_simple_string_HW1
	cmpb $57 ,%al # checks if lower than 9 - is a number
	jle next_char_HW1
	cmpb $63 ,%al # checks if ?
	je next_char_HW1
	cmpb $65 ,%al # checks if lower than A - not a simple string
	jl continue_from_simple_string_HW1
	cmpb $90 ,%al # checks if lower than Z - is an uppercase letter
	jle next_char_HW1
	cmpb $97 ,%al # checks if lower than a - not a simple string
	jl continue_from_simple_string_HW1
	cmpb $122 ,%al # checks if lower than z - is an lowercase letter
	jle next_char_HW1
	jmp continue_from_simple_string_HW1
next_char_HW1:
	incq %rdi 
	cmpq %rdi, %r15
	jne check_if_simple_string_HW
simple_string_HW1:
	movb $1,type
	jmp end_HW1

check_if_scientific_string_HW1:
	movb (%rsi,%rdi,1),%al
continue_from_simple_string_HW1:
	cmpb $32 ,%al # checks if ascii value is lower than 32
	jl check_if_divides_by_8_HW1
	cmpb $126 ,%al # checks if ascii value is higher than 126
	jg check_if_divides_by_8_HW1
	incq %rdi 
	cmpq %rdi, %r15
	jne check_if_scientific_string_HW1
Scientific_string_HW1:
	movb $2,type
	jmp end_HW1
check_if_divides_by_8_HW1:
	movq %rcx, %rax
	movq $8, %rbx
	xorl %edx, %edx
	divq %rbx
	testq %rdx, %rdx 
	jnz else_HW1
	shrq $3, %rcx # Divide size by 8 to get number of quads
	xorq %rdi, %rdi
	xorq %rax,%rax
check_non_zero_quads_HW1:
	cmpq %rcx, %rdi
	jge divided_by_0_non_0_quads_HW1 # if current iteration >= number of quads
	movq (%rsi,%rdi,8), %rax # load the currrent quad
	testq %rax, %rax # check if current quad is 0
	jz else_HW1
	incq %rdi # increase the index by 1
	jmp check_non_zero_quads_HW1
divided_by_0_non_0_quads_HW1:
	movb $3,type
	jmp end_HW1
else_HW1:
	movb $4,type
end_HW1:
	
	
