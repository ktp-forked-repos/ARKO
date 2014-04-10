.globl main

.data

nl:		.asciiz "\n"
dot:		.asciiz "."

file:		.asciiz "src_001.bmp"							#nazwa pliku
imgInfo:	.word 0,0,0									#w,h,size
pImg:	.space 80000
pSize:	.word 0x70008									#(rx:ry)								
ptrn:		.byte 0x43, 0x7d, 0x7d, 0x41, 0x3d, 0x3d, 0x3d, 0x40
pResult:	.word 0,0,0,0,0,0,0,0	
counter:	.word 0										
		
.text

main:	la $a0, pImg			#argument imgInfo* pImg
		la $a2, pSize	
		lw $a1, 0($a2)			#argument int pSize
		la $a2, ptrn			#argument int* ptrn
		la $a3 pResult			#argument Point* pResult
		jal FindPattern			#skok ze sladem do FindPattern
		j end

FindPattern:
		move $t7, $a0			#chroni argument a0
		move $t6, $a1			#chroni argument a1
		move $t5, $a2			#chroni argument a2
		
open:	li $v0, 13				#file open
		la $a0, file
		li $a1, 0x8000
		li $a2, 0444
		syscall
		move $t0, $v0			#deskryptor pliku w $t0
	
read:	li $v0, 14				#file read
		move $a0, $t0			#load deskryptor
		move $a1, $t7			#w t7 jest argument a0 = pImg
		li $a2, 80000			
		syscall				#ZAPISANO BITY OBRAZU
		la $t4, imgInfo
		sw $v0, 8($t4)			#ZAPISANO ROZMIAR
		ulw $t2, 18($t7)
		sw $t2, 0($t4)			#ZAPISANO SZEROKOSC
		ulw $t2, 22($t7)
		sw $t2, 4($t4)			#ZAPISANO WYSOKOSC
		
close:	li $v0, 16				#file close
		move $a0, $t0			#deskryptor pliku z $t0
		syscall
		move $a0, $t7			#przywraca oryginalna wart argumentu a0
		move $a1, $t6			#przywraca oryginalna wart argumentu a1
		move $a2, $t5			#przywraca oryginalna wart argumentu a2
		
		
		li $t1, 0				#t1=y=0
							#t2=rejestr bajtu
		lw $t3,0($t4)			#t3=w
							#t4=wskazanie na imgInfo
							#t5=ilosc bitow w zaokraglonej linii
		addu $t5, $t3, 31			#t5=w+31
		srl $t5, $t5, 5				#t5=(w+31)>>5
		sll $t5, $t5, 2				#t5=((w+31)>>5)<<2
		lw $t6, pSize			#t6=rx
		srl $t6, $t6, 16			
							#t7=licznik wystapien warst wzorca
		la $s0, imgInfo
		lw $s0, 4($s0)			#s0=h
							#s1=tmp byte
							#s2=tmp wzorzec
		lh $s3, pSize			#s3=ry
							#s4=wsk na aktualna linie wzorca
							#s5=licznik przesuniec
							#s6=wfound
							#s7=wfound
		move $t0, $t6			#t0=x=t6	
							#t8=trzyma t4
		
		
		addu $t4, $a0, 62		#obrazek przesuniety o 62 bajty
		
loadit:	li $t7, 0				#licznik wystapien warstw wzorca=0
		lbu $t2, 0($t4)			#bajt w $t2
		sll $t2, $t2, $t6			#przesun rejestr w lewo o szerokosc wzorca
		addu $s5, $s5, $t6
		la $s4, ptrn
		move $t0, $t6			#x=t6

ifok:		move $s1, $t2			#s1=tmp byte
		and $s1, $s1, 0x7f00	#and z maska
		lbu $s2, 0($s4)
		sll $s2, $s2, 8
		xor $s2, $s2, $s1
		move $t8, $t4			#przechowanie t4	
		beqz $s2, iffound
		j ifshift
	
iffound:	
		addu $s4, $s4, 1		#nastepny el wzorca
		addu $t7, $t7, 1		#licznik wystapien++
		beq $t7, $s3, found
		addu $t4, $t4, $t5		#poziom wyzej

		ulhu $s1, 0($t4)
		lbu $s1, -1($t4)
		sll $s1, $s1, 8
		lbu $t9, 0($t4)
		or $s1, $s1, $t9
		
		sll $s1, $s1, 8			
		sll $s1, $s1, $s5
		
		and $s1, $s1, 0x7f0000	#and z maska
		lbu $s2, 0($s4)
		sll $s2, $s2, 16
		xor $s2, $s2, $s1
		beqz $s2, iffound
		j ifshift
		
found:	ulw $s6, counter		#s6 - nr wystapienia
		la $s7, pResult			#s7 - wsk na tab wystapien
		addu $s7, $s7, $s6		#adekwatne przesuniecie
		sll $s6, $t0, 16			#na 16 starszych bitach x
		or $s6, $s6, $t1		#na 16 mlodszych bitach y
		usw $s6, ($s7)
		
		
		#TEST#
							move $s7, $a0
							move $a0, $t0
							li $v0, 1
							syscall
							la $a0, dot
							li $v0, 4
							syscall
							move $a0, $t1
							li $v0, 1
							syscall
							la $a0, nl
							li $v0, 4
							syscall
							move $a0, $s7
		#TEST#

		
		ulw $s6, counter		
		addu $s6, $s6, 1		#counter++
		usw $s6, counter

ifshift:	beq $t0, $t3, lineup
		move $t4, $t8								
		sll $t2, $t2, 1			#przesun wzorzec bitowy o 1
		addu $t0, $t0, 1		#x++
		addu $s5, $s5, 1		#licznik przesuniec++
		li $t7, 0				#licznik wystapien wzorca = 0
		la $s4, ptrn
		beq $s5, 8, addbyte		#if l.przes==8 dorzuc kolejny bit
		j ifok

addbyte:	li $s5, 0				#licznik przesuniec=0
		addu $t4, $t4, 1		#nastepny bajt
		lbu $s1, 0($t4)			#zaladuj do s1
		or $t2, $t2, $s1		#or nowego bajtu i przesunietego poprzedniego
		j ifok

lineup:	li $s5, 0				#licznik przesuniec=0
		move $t0, $t6			#x=t6
		addu $t1, $t1, 1		#y++
		beq $t1, $s0, koniec 	#gdy nie ma nic wyzej
		mul $t4, $t1, $t5		#y*il.bit.w.linii
		addu $t4, $t4, $a0
		addu $t4, $t4, 62
		j loadit

koniec:	la $v0, pResult			#wskaznik na tablice wspolrzednych w $v0
		la $v1, counter			#wskaznik na licznik wystapien wzorca w $v1
		jr $ra				#wyjscie z funkcji
		
end:		li $v0, 10
		syscall
	