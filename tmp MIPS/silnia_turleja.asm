        .globl   main 
        .data 
str1:   .ascii   "iteracyjne obliczanie silni\n" 
        .ascii   "Dariusz Turlej\n" 
        .asciiz  "wersja 0.001\n" 
str2:   .ascii   "\n" 
        .ascii   "wprowadz liczbê naturaln¹ [1..10]\n" 
        .ascii   "[0] - koniec programu\n" 
        .asciiz  "liczba = " 
str3:   .asciiz  "silnia = " 
# 
#       void main ( void ) 
# 
        .text 
main:   la       $v0,4                        # print_str 
        la       $a0,str1                     # a0 adres tekstu 
        syscall 
prompt: la       $v0,4                        # print_str 
        la       $a0,str2                     # a0 adres tekstu 
        syscall 
input:  la       $v0,5                        # read_int 
        syscall                               # v0 = int 
	la       $t0,10 
        bgtu     $v0,$t0,prompt 
        beq      $v0,$0,exit 
	
	
	
	
        jal      fact                         # fact (int) 
        sw       $v0,0($sp)                   # push fact (int) 
	
	
output: la       $v0,4                        # print_str 
        la       $a0,str3                     # a0 adres tekstu 
        syscall 
	
	
        lw       $a0,0($sp)                   # a0 = fact (int) 
        la       $v0,1                        # print_int 
        syscall 
        j        prompt 
	
	
	
exit:   la       $v0,10                       # exit 
        syscall 
	
	
	
# 
#       int fact( int n ) 
# 
        .text 
fact:   la       $s0,0($v0)                   # s0 = n 
        la       $v0,1                        # v0 = 1 
        bleu     $s0,$v0,end                  # n <= 1, end 
iter:   multu    $v0,$s0                      # 
        mflo     $v0                          # fact = fact * n 
        addiu    $s0,$s0,-1                   # n = n - 1 
        bgtz     $s0,iter 
end:    jr       $ra                          # return 
 