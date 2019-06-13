; ASM Code

.386
.MODEL FLAT,C

;
; DATA SECTION
;
.DATA

;
; CODE SECTION
;
.CODE

; function "int mysum(const int* nums, int count)"
mysum PROC public
    push ebp
    mov ebp, esp
    sub esp, 0          ; allocate stack space: 0 means no local variable
    mov edx, [ebp+8]    ; parameter 'nums'
    mov ecx, [ebp+12]   ; parameter 'count'
    xor eax, eax
mysumCalc:
    cmp ecx, 0
    je mysumDone
    dec ecx
    add eax, [edx]
    add edx, 4
    jmp mysumCalc
mysumDone:
    add eax, [ebp+12]   ; parameter 'b'
    pop ebp
    ret
mysum ENDP

; End of file
END