[ORG 0x00]
[BITS 16]

SECTION .text   ; text 세션정의

jmp 0x07C0:START ; 바이너리 위치 0x7c0위치에 저장

START:
    mov ax,0x07C0
    mov ds,ax
    mov ax,0xB800
    mov es,ax

    mov si,0

.SCREENCLEARLOOP:
    mov byte[es:si],0
    mov byte[es:si+1],0x0A
    add si,2
    cmp si,80*25*2
    jl  .SCREENCLEARLOOP

mov si,0
mov di,0



.BOOT_MESSAGE_STRING: db 'KUDE OS HELLO WORLD',0


jmp $

times 510 - ( $ - $$ ) db 0x00

db 0x55
db 0xAA