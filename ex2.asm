.global _start

.section .data
	data: .asciz "example data"
	type: .int 0
	size: .quad 12

.section .text
_start:
	movq size, %rcx
	leaq data, %rsi
	xorq %rdi, %rdi
	movb (%rsi,%rcx),%al #gets to the last char in data
	testb %al,%al # checks if the last char is a null terminator
	jnz check_if_divides_by_8_HW1
	xorb %al, %al
check_if_simple_string_HW:
	movb (%rsi,%rdi),%al
	cmpb $0 ,%al #if null terminator char
	je simple_string_HW1 #not sure if need to check if null terminator
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
	addq $1, %rdi 
	jmp check_if_simple_string_HW
simple_string_HW1:
	movq $1,type
	jmp end

check_if_scientific_string_HW1:
	movb (%rsi,%rdi),%al
	cmpb $0 ,%al #if null terminator char
	je Scientific_string_HW1
continue_from_simple_string_HW1:
	cmpb $32 ,%al # checks if ascii value is lower than 32
	jl check_if_divides_by_8_HW1
	cmpb $126 ,%al # checks if ascii value is higher than 126
	jg check_if_divides_by_8_HW1
	addq $1, %rdi 
	jmp check_if_scientific_string_HW1
Scientific_string_HW1:
	movq $2,type
	jmp end
check_if_divides_by_8_HW1:
	movq %rcx, %rax
	movq $8, %rbx
	divq %rbx
	testq %rdx, %rdx 
	jnz else_HW1
	shrq $3, %rcx # Divide size by 8 to get number of quads
	xorq %rdi, %rdi
	xorq %rax,%rax
check_non_zero_quads_HW1:
	cmpq %rcx, %rdi
	jge divided_by_0_non_0_quads_HW1 # if current iteration >= number of quads
	movq (%rsi,%rdi), %rax # load the currrent quad
	testq %rax, %rax # check if current quad is 0
	jz else_HW1
	addq $8, %rdi # increase the index by 8 bytes - quad
	jmp check_non_zero_quads_HW1
divided_by_0_non_0_quads_HW1:
	movq $3,type
	jmp end
else_HW1:
	mov $4,type
end:
	
	
	
	
