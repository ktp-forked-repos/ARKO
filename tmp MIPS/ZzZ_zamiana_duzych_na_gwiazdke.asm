#Komunikacja z u¿ytkownikiem, wczytanie ci¹gu znaków.
#Policzenie d³ugoœci ³añcucha znaków.
#Zamiana na * (w ASCII: 0x2A)
#- du¿ych liter (grupa 0)
#- ma³ych liter (grupa 1)

.globl main
.data
ciag: .space 80
kom1: .asciiz "Podaj ciag znakow: "
kom2: .asciiz "Dlugosc ciagu znakow to: "
kom3: .asciiz "Po zamianie duzych liter na gwiazdke ciag znakow wyglada tak:\n"

.text
main: 
	la $v0, 4	#ustawienie print_string
	la $a0, kom1	#print zachety wprowadzenia
	syscall		#wywolanie print_string

	la $v0, 8	#ustawienie read_string
	la $a0, ciag	#adres tekstu
	syscall		#wywolanie czytania ciagu
	
	b zamiana	#skok do zamiany na gwiazdki
		
	la $v0, 4	#print_str
	la $a0, kom2	#adres kom3
	syscall
	
	la $v0, 4	#print_str
	la $a0, ciag	#adres ciagu
	syscall


	
exit:
	la $v0, 10	#ustawienie exit
	syscall 	#wywolanie exit