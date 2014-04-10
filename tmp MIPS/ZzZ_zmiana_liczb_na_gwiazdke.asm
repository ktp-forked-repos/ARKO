.globl main

.data
witaj:	.asciiz "Elo, zapodaj tekst, ale nie wiecej niz 32 znaki."
oto:		.asciiz "Oto tekst po zamianie: "
datas:	.space 32

.text
main:	la $v0, 4
		la $a0, witaj
		syscall
		
czytaj:	la $v0, 8
		la $a0, datas
		syscall
		move $t1, $a0
		
spr: 		lb $t2, ($t1);
		blt $t2, 48, niecyfra
		bgt $t2, 57, niecyfra

niecyfra:	addiu $t1,1
		j spr
		
pisz:		la $v0, 4
		la $a0, oto
		syscall
		la $v0, 4
		la $a0, datas
		syscall
		



exit:		la $v0, 10
		syscall 