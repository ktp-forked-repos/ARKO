.globl main



.data

.text

main:	li $v0, 5
		syscall
		move $t0, $v0	 #t0 - nasza aktualna liczba
		la $t1, 2 		#t1 - 2
		
		addu $sp, 4
		move $s3, $sp	#s3 - pocz stosu
		
dziel:	beqz $t0 print
		div $t0, $t1
		mflo $t0
		mfhi $t3
		nop
		sb $t3, ($sp)
		addu $sp,-4
		j dziel

print:	beq $sp, $s3, end	
		lb $t4, ($sp)
		move $a0, $t4
		li $v0, 1
		syscall
		addu $sp, 4
		
		j print
		
end:		li $v0, 10
		syscall
		