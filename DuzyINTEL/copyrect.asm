;===============================================================
;
; imgInfo* copyrect(imgInfo* pImg, Rect* pSrc, Point* pDst);
;
;===============================================================
; STOS
;===============================================================
;
; wieksze adresy
; 
;  |                             |
;  | ...                         |
;  -------------------------------
;  | Point* pDst  		 | EBP+16
;  -------------------------------
;  | Rect* pSrc  		 | EBP+12
;  -------------------------------
;  | imgInfo* pImg  		 | EBP+8
;  -------------------------------
;  | adres powrotu               | EBP+4
;  -------------------------------
;  | zachowane ebp               | EBP, ESP
;  -------------------------------
;  | ... tu ew. zmienne lokalne  | EBP-x
;  |                             |
;
; \/                         \/
; \/ w te strone rosnie stos \/
; \/                         \/
;
; mniejsze adresy
;
;
;===============================================================

						%define pImg EBP+8
						%define pSrc EBP+12
						%define pDst EBP+16

;TODO
	;wyjscie za obrazek
	;wzorzec nie na poczatku bajtu
;TODO

section	.text

global  copyrect

extern printf

copyrect: 
	push ebp
	mov ebp, esp

read_store_dim:	
	mov ecx, [pSrc] 		;ecx=pSrc
	mov eax, [ecx]			;eax=xp
	mov ecx, [ecx+8]		;ecx=xk
	sub ecx, eax			;ecx=xk-xp
	add ecx, 1			;xk-xp+1
	push ecx			;ebp-4=width
						%define width EBP-4
	
	mov ecx, [pSrc] 		;ecx=pSrc
	mov eax, [ecx+4]		;eax=yp
	push eax				
						%define y1 EBP-8
	mov ecx, [ecx+12]		;ecx=yk
	push ecx				
						%define y2 EBP-12
	sub ecx, eax			;ecx=yk-yp
	add ecx, 1			;yk-yp+1	
	push ecx			;ebp-8=height
						%define height EBP-16
	
	mov eax, [pImg]			;eax=pImg
	mov eax, [eax]			;eax=pImg->width
	add eax, 31			;eax+31
	shr eax, 5			;eax>>5
	shl eax, 2			;eax<<2
	push eax			;ebp-12=lineBytes
						%define lineBytes EBP-20
	mul dword [height]
	sub eax, [lineBytes]
	push eax
						%define multiline EBP-24
	
	mov eax, [pDst]			;eax=pDst
	mov ecx, [eax]			;ecx=x
	push ecx
						%define x EBP-28
	shr ecx, 3			;x>>3	
	mov eax, [eax+4]		;eax=y
	push eax
						%define y EBP-32

	mul dword [lineBytes]		;eax=lineBytes*y
	add eax, ecx			;eax=mod_y+mod_x
	push eax			;ebp-16=delta_dst /number of bytes from 0.0 to x.y of destination/
						%define delta_dst EBP-36

	mov ecx, [pSrc]			;ecx=pSrc
	mov eax, [ecx+4]		;eax=yp
	mov ecx, [ecx]			;ecx=xp
	shr ecx, 3			;xp>>3
	mul dword [lineBytes]		;eax=mod_y
	add eax, ecx			;eax=mod_y+mod_x
	push eax			;ebp-20=delta_src /number of bytes form 0.0 to source's x.y/
						%define delta_src EBP-40
	
begin:	mov eax, [pImg]			;eax=pImg 
	mov ebx, [eax+8]		;ebx=pointer to first bit of img
	mov eax, ebx			;eax=pointer to first bit of img
	add eax, [delta_dst]		;eax points to first bit of destination
	add ebx, [delta_src]		;ebx points to first bit of source

mov ecx, dword [y]

spr1:	cmp ecx, dword [y1]
	jg spr2
	jmp dk

spr2:	cmp ecx, dword [y2]
	jl f_btm
	jmp dk

f_btm: 	add eax, [multiline]
	add ebx, [multiline]
	neg dword [lineBytes]

dk:	mov ecx, dword [x]		;x%8 gives another shift
	shl ecx, 27
	shr ecx, 27
	push ecx
						%define modulo EBP-44
	push dword 0				
						%define modulo2 EBP-48

loopy:	cmp [height], dword 0		;if ecx==0
	je end				;jump to end
	
	mov edx, 0xffffffff		;edx=111...111	
	mov ecx, dword [width]
	
shift1:	cmp ecx, 0			;shift to make a mask
	je con1
	sub ecx, 1
	shr edx, 1
	jmp shift1

con1:	not edx				;invert all bits
	mov ecx, dword [modulo]
	add [modulo2], ecx
						

shift2: cmp ecx, 0
	je con2
	sub ecx, 1
	shr edx, 1
	jmp shift2

con2:	bswap edx			;god bless this function!
	not edx				;negate mask to or it with bits of source
	mov ecx, [ebx]			;bits of source moved to ecx to avoid its change

	bswap ecx

shift3: cmp [modulo2], dword 0		;shift right to fit shift above
	je con3
	sub [modulo2], dword 1
	shr ecx, 1
	jmp shift3

con3:	bswap ecx
	or ecx, edx			;or to get 111...111|source|111...111
	not edx				;negate again to get previous form
	or edx, [eax]			;or mask with destination's bits	
	and edx, ecx			;and changed bit with source's bits
	mov [eax], edx			;move changed bit into right place

	add eax, [lineBytes]		;next line /dst/
	add ebx, [lineBytes]		;next line /src/
	sub [height], dword 1		;iterator--
	jmp loopy			

end:

;TEST
push	dword [height]
push	dword pisz	
call	printf		
add	esp, 2*4	
;TEST


	cmp [width], dword 32
	jle end2
	
	sub [width], dword 32
	add [x], dword 32
	
	add [delta_src], dword 3
	add [delta_dst], dword 3
	sub eax, [multiline]
	sub ebx, [multiline]
	neg dword [lineBytes]
	mov ecx, [pSrc] 		;ecx=pSrc
	mov eax, [ecx+4]		;eax=yp
	mov ecx, [ecx+12]		;ecx=yk
	sub ecx, eax			;ecx=yk-yp
	add ecx, 1			;yk-yp+1	

	mov [height], dword ecx

spr1a:	cmp ecx, dword [y1]
	jg spr2a
	jmp dka

spr2a:	cmp ecx, dword [y2]
	jl f_btma
	jmp dka

f_btma: sub eax, [multiline]
	sub ebx, [multiline]
	neg dword [lineBytes]



dka:	jmp begin


end2:	leave 				;mov esp, ebp
					;pop ebp
	ret

section .data

pisz: db "%d", 10, 0
