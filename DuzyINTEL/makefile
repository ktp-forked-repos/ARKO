CC=gcc
ASMBIN=nasm

all : asm cc link
asm : 
	$(ASMBIN) -o asm.o -f elf -l copyrect.lst copyrect.asm
cc :
	$(CC) -m32 -c -g -O0 -fpack-struct copyrect.cc &> errors.txt
link :
	$(CC) -m32 -o test -lstdc++ copyrect.o asm.o
clean :
	rm *.o
	rm test
	rm errors.txt	
	rm copyrect.lst
