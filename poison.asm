    .586p
    .model flat, stdcall
    option casemap :none   ; case sensitive

    include \masm32\include\windows.inc
    include \masm32\include\user32.inc
    include \masm32\include\kernel32.inc

    includelib \masm32\lib\user32.lib
    includelib \masm32\lib\kernel32.lib

.data
ProgTitle    db   "VGA poison dll",0
sz_text      db   "Injected with the poison !",0

.code
program:

LibMain proc hInstDLL:DWORD, reason:DWORD, unused:DWORD
	
	.if reason == DLL_PROCESS_ATTACH
		invoke MessageBox, 0, offset sz_text, offset ProgTitle, 0
		xor eax,eax
	    inc eax
	    ret
	.else
        xor eax,eax
	    inc eax
	    ret
	.endif


LibMain endp

placeholder proc

    xor eax,eax
	ret

placeholder endp



end program


