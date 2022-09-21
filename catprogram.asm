%define stdin 0
%define stdout 1
%define stderr 2

%macro fprint 3

        mov eax, 4
        mov ebx, %1
        mov ecx, %2
        mov edx, %3
        int 80h

%endmacro

%macro fgets 3

        mov eax, 3
        mov ebx, %1
        mov ecx, %2
        mov edx, %3
        int 80h

_checkbuf:
        cmp byte[%2+%3-1], 0x0
        je _exit

_clearbuf:
        mov eax, 3
        mov ebx, %1
        mov ecx, buf
        mov edx, buf_len
        int 80h

        cmp byte[buf], 0xA
        jne _clearbuf
        mov byte[%2+%3-1], 0xA

_exit:

%endmacro

%macro return 1

        mov eax, 1
        mov ebx, %1
        int 80h

%endmacro

section .bss
input_len: equ 255
input: resb input_len
buf_len: equ 1
buf: resb buf_len

section .data
prompt: db "Enter Anything For It To Be Repeated!", 0xA, "Input: "
prompt_len: equ $-prompt
text: db "You Said: "
text_len: equ $-text

section .text
global _start
_start:
        fprint stdout, prompt, prompt_len
        fgets stdin, input, input_len
        fprint stdout, input, input_len
        return 0
