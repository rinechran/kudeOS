[ORG 0x00]
[BITS 16]

SECTION .text


mov ax,0xB800
mov ds,ax

mov byte[0x00],'K'
mov byte[0x02],'U'
mov byte[0x04],'D'
mov byte[0x06],'E'

jmp $

times 510 - ( $ - $$ ) db 0x00



db 0x55
db 0xAA