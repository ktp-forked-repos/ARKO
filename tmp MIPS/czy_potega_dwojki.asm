.globl main
.data

witka:	.ascii	"Podaj liczbe, z zakresu [0 , ... , 10],\n"
	.asciiz	"aby sprawdzic, czy jest potega dwojki\n"
jest:	.asciiz	" jest potega dwojki"
nie:	.asciiz " nie jest potega dwojki"

.text
main:	la $t0, 2
	la $v0, 4 	#print_str
	la $a0, witka 	#adres witka
	syscall

	la $v0, 5	#read_int
	syscall
	bgt $v0, 10, main

spr1:	beq $v0, 1, ok

spr2:	beq $v0, $t0, ok
	mulo $t0, $t0, 2
	bgt $t0, 10, bad
	j spr2

ok:	la $v0, 4
	la $a0, jest
	syscall
	j end
	
bad:	la $v0, 1
	la $v0, 4
	la $a0, nie
	syscall
	

end:	la $v0, 10
	syscall 