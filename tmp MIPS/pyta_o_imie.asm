.globl main
.data
imie:	.space 80
pyt:	.asciiz "Jak masz na imie?\n"
odp: 	.asciiz "Czesc "

.text

main:
	la $v0, 4
	la $a0, pyt
	syscall
	
	la $v0, 8
	la $a0, imie
	syscall
		
	la $v0, 4
	la $a0, odp
	syscall

	la $v0, 4
	la $a0, imie
	syscall
	
exit:	la $v0, 10
	syscall