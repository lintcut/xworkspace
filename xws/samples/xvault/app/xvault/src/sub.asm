; ASM Code

ifndef X64
.386
.MODEL flat,stdcall
endif

;
; DATA SECTION
;
.DATA

;
; CODE SECTION
;
.CODE

; function "int mysub(int a, int b)"
mysub PROC public
ifndef X64
    push ebp
    mov ebp, esp
    sub esp, 0
    mov eax, [ebp+8]    ; parameter 'a'
    sub eax, [ebp+12]   ; parameter 'b'
    pop ebp
else
    push rbp
    mov rbp, rsp
    sub rsp, 0
    mov eax, [rbp+8]    ; parameter 'a'
    sub eax, [rbp+12]   ; parameter 'b'
    pop rbp
endif
    ret
mysub ENDP

; End of file
END