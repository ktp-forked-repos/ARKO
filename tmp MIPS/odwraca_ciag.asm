.globl main

.data
helo:	.asciiz "Witaj, podaj ciag do zamiany: "
ciag:		.space 100
done:	.asciiz "Ciag po przeksztalceniu to: "

#s0 - licznik
#s1 - N/2

#s5 - poczatek ciagu
#s6 - aktualny znak
#s7 - aktualny znak porownanie
#t0 - chwilowa zmienna na znak



.text

main:	la $s0, 0	#licznik=0
		la $s1, 0	#wskaznik srodka
		la $v0, 4
		la $a0, helo
		syscall

czytaj:	la $v0, 8
		la $a0, ciag
		syscall
		
		la	$s6, ciag
		move $s5, $s6 #poczatek ciagu w $s5
		
mierz: 	lb $s7, ($s6)
		blt 	$s7, 32, dziel
		addu $s1, 1
		addu $s6, 1
		j mierz
		
		
#dziel:	div $s1, $s1, 2	#wysnaczamy N/2
#
#		la $v0, 1
#		move $a0, $s1
	#	syscall
		
	#	move $s5, $s6
				
#odwroc:	beq	$s0, $s1, pisz 	#jesli doszlismy do N/2 to koniec
#		add $s0, $s0, 1
#		lb $s7, ($s6)
#		move $t0, $s7
#		addu $s6, $s1
#		lb $s7, ($s6)
#		
#		addu $s6, 1
#		j odwroc			#skacz do odwroc /petla/
		
pisz:		la $v0, 4
		la $a0, done
		syscall
		la $v0, 4
		la $a0, ciag
		syscall


		
		
end:		la $v0, 10
		syscall
