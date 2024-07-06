.global _start

_start:
	movl length, %ecx 
	# no use in checking if length is 0 because even if it is the index is bigger or 0 and will go to not_legal_HW1
	movl Index, %edi 
	cmpl %ecx, %edi
	jae not_legal_HW1 #if length<=index (index starts from 0)
	movl $1, Legal
	leaq Adress,%rsi
	movq (%rsi), %rsp
    cmpq $0, %rsp # check if address is negative (overflows)
    jle not_legal_HW1
    testq %rsp,%rsp # check if adress is null 
    jz not_legal_HW1
    movl (%rsp,%rdi,4), %eax
	movl %eax,num
	jmp end_HW1
not_legal_HW1:
	movl $0, Legal
end_HW1:
