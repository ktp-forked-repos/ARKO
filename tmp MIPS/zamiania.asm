        .globl main
        .data

napis1: .asciiz "\nPodaj fraze: "
napis2: .asciiz "Dlugosc lancucha: "
napis3: .asciiz "\nPrzetworzony tekst: "
bufor:  .space 256

        .text

main:
        li      $v0, 4
        la      $a0, napis1
        syscall

        li      $v0, 8                  # wczytywanie lancucha znakow
        la      $a1, 255
        la      $a0, bufor
        syscall

        move    $s0, $a0                # $s0 - poczatek lancucha
        li      $t0, 0                  # $t0 - licznik znakow

liczymy:
        lb      $t1, 0($a0)             # $t1 - aktualny znak
        beqz    $t1, koniec
        addi    $t0, $t0, 1
        blt     $t1, 91, zmien
        addi    $a0, $a0, 1
        b	liczymy

zmien:	
        blt     $t1, 65, nie
        li      $t1, 0x2A
        sb      $t1, 0($a0)

nie:
        addi    $a0, $a0, 1
        b       liczymy

koniec:
        addi    $t0, $t0, -1           #bo policzyl o 1 za duzo
        li      $v0, 4
        la      $a0, napis2
        syscall

        li      $v0, 1
        move    $a0, $t0
        syscall

        li      $v0, 4
        la      $a0, napis3
        syscall

        li      $v0, 4
        move    $a0, $s0
        syscall

        li      $v0, 10
        syscall