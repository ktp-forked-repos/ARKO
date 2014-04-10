.globl main 
.data

dane:	.word	5,125,321,89,125,401,8,-1
stri:	 .asciiz   "Podaj liczbe: "
str2:	.asciiz   "Ilosc liczb mniejszych: "
n:	.asciiz    "\n"
str3:	.asciiz  "Dlugosc ciagu: "

.text
#t0-liczba podana
#t1-tablica
#t2-aktualny bit
#t3-licznik all
#t4-licznik mniejszych

main:	la $t3, 0
		la $t4, 0
		li $v0, 4
		la $a0, stri
		syscall
		li $v0, 5
		syscall

		move $t0, $v0

		la $t1, dane
		
petla:	lwr $t2, 0($t1)		#laduje znak do t2	
		beq $t2, -1, end
		addu $t3, 1		#zas jelsi jest to zwiekszamy licznik all
		bge $t2, $t0,inca	#jest liczba wieksza niz podana to next
		addu $t4,1		#jesli nie to zwiekszamy licznik
		
inca:		addu $t1, 4
		j petla
		
end:		li $v0, 4
		la $a0, str3
		syscall
		li $v0, 1
		move $a0,$t3
		syscall
		li $v0, 4
		la $a0, n
		syscall
		li $v0, 4
		la $a0, str2
		syscall
		li $v0, 1
		move $a0, $t4
		syscall
		li $v0, 10
		syscall
