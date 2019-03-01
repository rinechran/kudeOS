[ORG 0x00]
[BITS 16]

SECTION .text   ; text 세션정의

jmp 0x07C0:START ; 바이너리 위치 0x7c0위치에 저장

TOTAL_SECTOR_COUNT: dw 1024


START:
    mov ax,0x07C0
    mov ds,ax
    mov ax,0xB800
    mov es,ax
    
    mov ax,0x0000
    mov ss,ax
    mov sp,0xFFFE
    mov bp,0xFFFE 


    mov si,0

SCREEN_CLEAR_LOOP:
    mov byte[es:si],0
    mov byte[es:si+1],0x0A
    add si,2
    cmp si,80*25*2
    jl  SCREEN_CLEAR_LOOP



;; ============================
;; boot start message
;; ============================
push BOOT_MESSAGE_STRING
push 1
push 0
call FUNPRINT_MESSAGE
add sp,6

jmp $
;; bp + 4 x
;; bp + 6 y
;; bp + 8 show_string 
FUNPRINT_MESSAGE:
    push bp
    mov bp,sp

    push es
    push si
    push di
    push ax
    push cx
    push dx

    mov ax,0xB800
    mov es,ax ; es register setting to defaulf video address

    mov ax,word[bp+6] ;; y setting
    mov si,160
    mul si ; ax * si
    mov di, ax

    mov ax,word[bp+4] ;; x setting
    mov si,2
    mul si
    add di,ax

    mov si,word[bp+8]

    MESSAGELOOP:
        mov cl,byte [si]
        cmp cl,0

        je MESSAGEEND

        mov byte[es:di],cl

        add si,1
        add di,2
        
        jmp MESSAGELOOP

    MESSAGEEND:
        pop dx
        pop cx
        pop ax
        pop di
        pop si
        pop es

        mov sp,bp
        pop bp
        ret

BOOT_MESSAGE_STRING: db 'KUDE OS HELLO WORLD',0




times 510 - ( $ - $$ ) db 0x00

db 0x55
db 0xAA