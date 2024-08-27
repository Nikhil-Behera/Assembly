section .data
    msg1 db 10d, "Enter first string: ", 0
    len1 equ $-msg1

    msg2 db 10d, "Enter second string: ", 0
    len2 equ $-msg2

    msg3 db 10d, "Concatenated string: ", 0
    len3 equ $-msg3

    msg4 db 10d, " ", 0ah, 0
    len4 equ $-msg4

section .bss
    str1 resb 25
    l1 resb 1

    str2 resb 25
    l2 resb 1

    str3 resb 50
    l3 resb 1

section .text
    global _start

    %macro mac 4
        mov rax, %1
        mov rdi, %2
        mov rsi, %3
        mov rdx, %4
        syscall
    %endmacro

_start:
    ; Read first string
    mac 1, 1, msg1, len1         ; Write "Enter first string: "
    mac 0, 0, str1, 25           ; Read first string into str1
    dec rax                      ; rax now contains the length of the string - 1 (to remove the newline)
    mov [l1], al                 ; Store the length in l1

    ; Read second string
    mac 1, 1, msg2, len2         ; Write "Enter second string: "
    mac 0, 0, str2, 25           ; Read second string into str2
    dec rax                      ; rax now contains the length of the string - 1 (to remove the newline)
    mov [l2], al                 ; Store the length in l2

    ; Concatenate strings
    call concat

    ; Print the concatenated string
    mac 1, 1, msg3, len3         ; Write "Concatenated string: "
    mac 1, 1, str3, [l3]         ; Write the concatenated string

    ; Exit
    mac 60, 0, 0, 0              ; Exit

concat:
    ; Calculate the total length of the concatenated string
    mov al, [l1]                 ; Load length of str1 into al
    add al, [l2]                 ; Add length of str2
    mov [l3], al                 ; Store the total length in l3

    ; Copy str1 to str3
    mov rsi, str1                ; rsi points to str1
    mov rdi, str3                ; rdi points to str3

copy1:
    mov al, [rsi]                ; Load byte from str1
    mov [rdi], al                ; Store it in str3
    inc rsi                      ; Increment source index
    inc rdi                      ; Increment destination index
    dec byte [l1]                ; Decrement length counter
    jnz copy1                    ; Repeat until all bytes copied

    ; Copy str2 to str3
    mov rsi, str2                ; rsi points to str2

copy2:
    mov al, [rsi]                ; Load byte from str2
    mov [rdi], al                ; Store it in str3
    inc rsi                      ; Increment source index
    inc rdi                      ; Increment destination index
    dec byte [l2]                ; Decrement length counter
    jnz copy2                    ; Repeat until all bytes copied

    ret                          ; Return from concat
