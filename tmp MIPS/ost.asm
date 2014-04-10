.globl main
.data
bufor:	.space 80
znak:	.asciiz " "
.text
main:	li $v0, 8
		la $a0, bufor
		syscall
		li $v0, 8
		la $a0, znak
		syscall
		
		lb $t4,($a0)	#znak
		la $t0, bufor	#bufor
		la $t2, 0		#licznik
		la $t3, -1		#wynik
		
loop:	lb $t1, ($t0)
		blt $t1, 32, end	#jesli koneic ciagu to idz do end
		beq $t1, $t4, jest
		addu $t0, 1
		addu $t2, 1
		j loop

		
jest:		move $t3, $t2
		addu $t0, 1
		addu $t2, 1
		j loop



end:		li $v0, 1
		move $a0, $t3
		syscall
		li $v0, 10
		syscall 