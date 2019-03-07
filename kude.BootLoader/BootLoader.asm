[ORG 0x00]
[BITS 16]

SECTION .text   ; text 세션정의

jmp 0x07C0:START ; START 

SECTOR_TOTAL_COUNT: dw 1024

DISK_SECTOR_INDEX : db 0x02
DISK_HEAD_INDEX : db 0x00
DISK_TRACK_INDEX : db 0x00



;; ========================
;; ds = 0x07c0 , ex = 0xb800 , sp = 0xfffe , bp = oxfffe 
;; init
;; ========================
START:
    mov ax,0x07C0
    mov ds,ax
    mov ax,0xB800
    mov es,ax
    
    mov ax,0x0000
    mov ss,ax
    mov sp,0xFFFE ;; SP register start 0xffff
    mov bp,0xFFFE ;; BP register start 0xffff


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

BOOT_MESSAGE:
    push BOOT_MESSAGE_STRING
    push 0
    push 0
    call PRINT_MESSAGE_FUNC
    add sp,6

    push BOOT_LOADING_STRING
    push 1
    push 0 
    call PRINT_MESSAGE_FUNC
    add sp,6


INIT_DSIK:

    mov ax,0
    mov dl,0
    int 0x13 ; disk io service interrupt 0x13
    jc BOOT_ERROR_FUNC

    mov si,0x1000
    mov es,si  
    mov bx,0x0000
    mov di, word [SECTOR_TOTAL_COUNT]
 
READ_DISK_FUNC:
    cmp di,0
    je READ_END_FUNC
    sub di,0x01

    mov ah,0x02 ; sector mode
    mov al,0x01 ; sector read size
    mov ch,byte[DISK_TRACK_INDEX]
    mov cl,byte[DISK_SECTOR_INDEX]
    mov dh,byte[DISK_HEAD_INDEX]
    mov dl,0x00
    int 0x13 ; disk io service interrupt 0x13
    jc BOOT_ERROR_FUNC

    add si,0x0020 ; 1 sctor size 0x200 size
    mov es,si

    mov al,byte[DISK_SECTOR_INDEX]
    add al,0x01
    mov byte[DISK_SECTOR_INDEX],al ;; al sctor index ++
    cmp al,19
    jl READ_DISK_FUNC


    xor byte [ DISK_HEAD_INDEX ], 0x01  ; head number xor toggle
    mov byte [DISK_SECTOR_INDEX], 0x01  ; 1 setting

    cmp byte[DISK_HEAD_INDEX],0x00
    jne READ_DISK_FUNC

    add byte [ DISK_TRACK_INDEX ] , 0x01 ; track number ++
    jmp READ_DISK_FUNC


READ_END_FUNC:
    push BOOT_COMPLETE_STRING
    push 1
    push 0
    call PRINT_MESSAGE_FUNC
    add sp,6
    jmp 0x1000:0x0000          

    

BOOT_ERROR_FUNC:
    push BOOT_DISK_ERROR_STRING
    push 10
    push 0
    call PRINT_MESSAGE_FUNC
    add sp,6
    jmp $


;; ====================
;; printf function
;; parm ==>
;; bp + 4 x
;; bp + 6 y
;; bp + 8 show_string 
;; ====================
PRINT_MESSAGE_FUNC:
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





BOOT_DISK_ERROR_STRING : db 'DISK ERROR',0
BOOT_MESSAGE_STRING: db 'KUDE OS HELLO WORLD',0
BOOT_LOADING_STRING : db 'OS IMAGE LOADING ......',0
BOOT_COMPLETE_STRING : db 'OS IMAGE LOADING COMPLETE ',0


jmp $
times 510 - ( $ - $$ ) db 0x00

db 0x55
db 0xAA