; ASM Code

.386
.MODEL flat,stdcall

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
    push ebp
    mov ebp, esp
    sub esp, 0
    mov eax, [ebp+8]    ; parameter 'a'
    sub eax, [ebp+12]   ; parameter 'b'
    pop ebp
    ret
mysub ENDP

; End of file
END