.globl main
.data
str1:	.asciiz "Aasa19AAA2802aba2sasjaksjkJs"
.text

main:	la $a0, str1
		jal stricnv
		move $a0, $v0
		li $v0,4
		syscall
		li $v0,10
		syscall
	
stricnv:	move $t0, $a0	#t0-wsk do czytania
		move $t1, $a0	#t1-wsk do pisania
		move $t3, $a0 #t3-tmp
		
petla:	lb $t7, ($t0)
		beqz $t7, end
	
warml1:	bge $t7, 'a', warml2
wardl1:	bge $t7, 'A', wardl2	
warc1:	bge $t7, '0', warc2
		addu $t0, 1
		b petla
	
warml2:	ble $t7, 'f', pisz
		addu $t0, 1
		b petla
		
wardl2:	ble $t7, 'F', pisz
		addu $t0, 1
		b petla	
	
warc2:	ble $t7, '9', pisz
		addu $t0, 1
		b petla

pisz:		sb $t7, ($t1)
		addu $t0, 1
		addu $t1, 1
		b petla
	
end:		sb $zero, ($t1)

		addu $t1, -1
zamien:	bge $t3, $t1, ix
		lb $t6, ($t1)
		lb $t5, ($t3)
		sb $t5, ($t1)
		sb $t6, ($t3)
		addu $t3,1
		addu $t1,-1
		b zamien

ix:		move $v0, $a0
		jr $ra
