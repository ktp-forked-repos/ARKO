.data

buf:		.space 80

.text
.globl main


main:	la	$a0, buf	#pod a0 bedzie bufor
		li	$a1, 80	#pod a1 mamy 80
		li	$v0, 8	#czytamy do bufora
		syscall

		la	$t0, buf	#do t0 dajemy bufor
		li	$t1, 0	#do t1 dajemy 0

		move $t7, $t0
		
nextchar: 	lbu	$t2,($t0)			#do t2 idzie 1 znak z t0
		addu	$t0, 1			#idziemy na nastepny znak w ciagu
		bltu	$t2, ' ', fin			#jesli t2 nie jest znakiem idziemy do konca
		bltu	$t2, '0', nextchar	#jesli nie liczba idziemy do nastepnego znaku
		bgtu	$t2, '9', nextchar	#j.w
		addu $t0,-1
		la $t2, '*'
		sb $t2, ($t0)
		addu $t0, 1
				
		addu	$t1, 1			#inkrementujemy licznik wystapien liczby
		b	nextchar			#petla, wiec wraca

		
fin:		move	$a0, $t1		#przepychamy do a0, licznik
		li	$v0, 1			#dajemy print_int
		syscall				#wywolujemy
		move	$a0, $t7
		la $v0, 4
		syscall
		li	$v0, 10			#dajemy exit
		syscall 				#wywolujemy