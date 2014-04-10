;=====================================================================
; 
; char* strrstr(char* txt, char*pt)
;
;=====================================================================

section	.text
global  strrstr

strrstr:
	push	ebp
	mov	ebp, esp
	
	mov	ebx, [ebp+8]
	mov	ecx, [ebp+12]
	xor eax,eax
	mov dh, [ecx]

petla:
	mov dl, [ebx]
	cmp dl,0
	jz end
	cmp dl,dh
	jz zapisz
	inc ebx
	jmp petla
zapisz:
	mov esi,eax
	mov eax,ebx
petla_next:
	mov dh,[ecx]
	cmp dh,0
	jz found
	mov dl,[ebx]
	cmp dl,0
	jz przenies_end
	cmp dh,dl
	jnz zeruj
	inc ebx
	inc ecx
	jmp petla_next
zeruj:
	mov eax,esi
found:
	mov ecx,[ebp+12]
	mov dh,[ecx]
	jmp petla
przenies_end:
	mov eax,esi
end:
	pop	ebp
	ret
	
;============================================
; STOS
;============================================
;
; wieksze adresy
; 
;  |                             |
;  | ...                         |
;  -------------------------------
;  | parametr funkcji - char *a  | EBP+8
;  -------------------------------
;  | adres powrotu               | EBP+4
;  -------------------------------
;  | zachowane ebp               | EBP, ESP
;  -------------------------------
;  | ... tu ew. zmienne lokalne  | EBP-x
;  |                             |
;
; \/                         \/
; \/ w ta strone rosnie stos \/
; \/                         \/
;
; mniejsze adresy
;
;
;============================================

	
	
