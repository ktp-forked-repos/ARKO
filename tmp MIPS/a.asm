.globl main

.data
tab1: .space 10
litera: .asciiz " "
.text
main:li $v0, 8
	la $a0, tab1
	syscall
	
petla:	bgt $s1, 10, pisz
	



pisz: li $v0, 4
	la $a0, litera
	syscall
	
end: li $v0, 10
	syscall