; ASM Code

ifndef X64
.386
.MODEL FLAT,C
endif

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
ifndef X64
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
else  ; ifndef X64
    push rbp
    mov rbp, rsp
    sub rsp, 0          ; allocate stack space: 0 means no local variable
    mov edx, [rbp+8]    ; parameter 'nums'
    mov ecx, [rbp+12]   ; parameter 'count'
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
    pop rbp
endif ; ifndef X64
    ret
mysum ENDP

; End of file
END