#-------------------------------------------------------------------------------
#autor: Zbigniew Szymanski
#data : 2002.11.01
#opis : Program wczytuje ciag znakowy z klawiatury i wyswietla go 
#-------------------------------------------------------------------------------

	.data
input:	.space 80
prompt:	.asciiz "\nPodaj ciag znakow> "
msg1:	.asciiz "\nWczytany ciag    > "
	.text
main:

#wyswietlenie zapytania
        li $v0, 4		#system call for print_string
        la $a0, prompt		#address of string 
        syscall

#wczytanie ciagu znakowego
        li $v0, 8		#system call for read_string
	la $a0, input		#address of buffer    
	syscall
	    
#wyswietlenie komunikatu msg1 + wczytanego ciagu
        li $v0, 4		#system call for print_string
        la $a0, msg1		#address of string 
        syscall
        li $v0, 4		#system call for print_string
        la $a0, input		#address of string 
        syscall

exit:	li 	$v0,10		#Terminate
	syscall
