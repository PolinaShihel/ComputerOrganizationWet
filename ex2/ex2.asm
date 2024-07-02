.global _start

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
	movq $3,type
	jmp end
else_HW1:
	mov $4,type
end:
	
# Print "type="
    movq $1, %rax            # syscall number for sys_write
    movq $1, %rdi            # file descriptor (stdout)
    lea type_label(%rip), %rsi   # address of type_label
    movq $5, %rdx            # number of bytes to write (length of "type=")
    syscall                  # make the syscall to print "type="

    # Convert the value of 'type' to a string
    movl type(%rip), %eax    # move the value of type into %eax
    movq $type_buf + 12, %rsi # point to the end of the buffer
    movb $0, (%rsi)          # null-terminate the string

convert_type_to_str:
    dec %rsi                 # move pointer backwards
    movl $10, %ecx           # base 10
    xor %edx, %edx           # clear %edx for division
    div %ecx                 # divide %eax by 10
    addb $'0', %dl           # convert remainder to ASCII
    movb %dl, (%rsi)         # store character in buffer
    test %eax, %eax          # check if quotient is zero
    jnz convert_type_to_str  # loop if quotient is not zero

    # Print the string representation of 'type'
    movq $1, %rax            # syscall number for sys_write
    movq $1, %rdi            # file descriptor (stdout)
    movq %rsi, %rdx          # length of the string
    movq $type_buf + 12, %rcx
    sub %rsi, %rcx           # calculate the string length
    movq %rsi, %rsi          # address of the string
    movq %rcx, %rdx          # number of bytes to write
    syscall                  # make the syscall to print type

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
type_label:
    .asciz "type="
newline:
    .byte 10                 # ASCII code for newline ('\n')

.section .bss
    .lcomm type_buf, 13      # buffer to hold string representation of type
	
	
	
