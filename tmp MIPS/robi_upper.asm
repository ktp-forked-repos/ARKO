.globl main
.data
newline: .asciiz "\n"
litera: .asciiz " "
.text
main:

#uzyskanie pamieci
li $a0,11   #amount
li $v0,9    #sbrk
syscall     #adres w v0

move $s0,$v0 # zapisuje adres pamieci do s0

move $a0,$s0  #buffer
li $v0,8    #read_string
li $a1,11   #length
syscall  # zapisuje do bufora length znakow (10)

petla:

lb $s1,($s0)
beqz $s1,koniec #branch if zero

ble $s1,90,wyswietl  #branch less equal
addi $s1,-32

wyswietl:
sb $s1, litera

li $v0,4
la $a0, litera
syscall

addi $s0,1
b petla

koniec:
#wypisanie
#li $v0,4
#move $a0, $s0
#syscall

li $v0,4
la $a0, newline
syscall

li $v0,10
syscall