.global _start

.section .data
	Adress: 
		.int 10,20,30,40,50,60
	Index:
		.int 2
	length:
		.int 6
	Legal:
		.int 0
	num:
		.int 0
	format_str_num: .asciz "num = %d\n"
    format_str_legal: .asciz "Legal = %d\n"

.section .text
_start:
	movl length, %ecx
	movl Index, %edi 
	cmp %ecx, %edi
	jae not_legal_HW1 #if length>=index (index starts from 0)
	movl $1, Legal
	leaq Adress,%rsi
	movl (%rsi,%rdi,4), %eax
	movl %eax,num
	jmp end
not_legal_HW1:
	movl $0, Legal
end:

print_values:
    # Print num
    lea format_str_num(%rip), %rdi    # Load address of format string for num into rdi
    mov num(%rip), %esi               # Load value of num into esi
    xor %eax, %eax                    # Clear eax (no floating point arguments)
    call printf                       # Call printf to print num

    # Print Legal
    lea format_str_legal(%rip), %rdi  # Load address of format string for Legal into rdi
    mov Legal(%rip), %esi             # Load value of Legal into esi
    xor %eax, %eax                    # Clear eax (no floating point arguments)
    call printf                       # Call printf to print Legal

    # Exit the program
    mov $60, %rax                     # syscall: sys_exit
    xor %rdi, %rdi                    # status: 0
    syscall                           # invoke the system call

# External function
.extern printf
