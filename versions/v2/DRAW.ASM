; ▀████    ▐████▀ ████████▄     ▄████████    ▄████████    ▄█   ▄█▄    ▄████████  ▄██████▄  ███    █▄   ▄█       
;   ███▌   ████▀  ███   ▀███   ███    ███   ███    ███   ███ ▄███▀   ███    ███ ███    ███ ███    ███ ███       
;    ███  ▐███    ███    ███   ███    ███   ███    ███   ███▐██▀     ███    █▀  ███    ███ ███    ███ ███       
;    ▀███▄███▀    ███    ███   ███    ███  ▄███▄▄▄▄██▀  ▄█████▀      ███        ███    ███ ███    ███ ███       
;    ████▀██▄     ███    ███ ▀███████████ ▀▀███▀▀▀▀▀   ▀▀█████▄    ▀███████████ ███    ███ ███    ███ ███       
;   ▐███  ▀███    ███    ███   ███    ███ ▀███████████   ███▐██▄            ███ ███    ███ ███    ███ ███       
;  ▄███     ███▄  ███   ▄███   ███    ███   ███    ███   ███ ▀███▄    ▄█    ███ ███    ███ ███    ███ ███▌    ▄ 
; ████       ███▄ ████████▀    ███    █▀    ███    ███   ███   ▀█▀  ▄████████▀   ▀██████▀  ████████▀  █████▄▄██     
;
;  _   _      _                _ _        _              _____                 _ _               _           _ _        ___                      
; | | | |_ _ (_)_ _____ _ _ __(_) |_ __ _| |_ ___ __ _  |_   _| _ __ _ _ _  __(_) |_ ____ _ _ _ (_)__ _   __| (_)_ _   | _ )_ _ __ _ ___ _____ __
; | |_| | ' \| \ V / -_) '_(_-< |  _/ _` |  _/ -_) _` |   | || '_/ _` | ' \(_-< | \ V / _` | ' \| / _` | / _` | | ' \  | _ \ '_/ _` (_-</ _ \ V /
;  \___/|_||_|_|\_/\___|_| /__/_|\__\__,_|\__\___\__,_|   |_||_| \__,_|_||_/__/_|_|\_/\__,_|_||_|_\__,_| \__,_|_|_||_| |___/_| \__,_/__/\___/\_/ 
; DRAW.ASM

start:
    call set_video_mode

    mov cx, 100
    mov dx, 101
    mov bx, 200
    mov al, 15
    call draw_line_h

    mov ah, 00h         ; read key press
    int 16h             ; wait for a key press

    call set_text_mode
    mov  ah, 4Ch        ; DOS terminate
    int  21h


; ---------------------------
; Set video mode (BIOS int)
; ---------------------------
set_video_mode:
    mov  ah, 00h       ; BIOS set video mode
    mov  al, 13h       ; 320x200 256 color mode
    int 10h

    mov ax, 0A000h     ; A000h is the segment of the video memory
    mov es, ax         ; Load the segment into ES
    ret

; ---------------------------
; Set text mode (BIOS int)
; ---------------------------
set_text_mode:
    mov  ax, 03h        ; BIOS set video mode
    mov  bh, 00h        ; text mode
    int  10h
    ret

; ---------------------------
; Fast direct pixel plotting
; Input: CX = x, DX = y, AL = color
; ---------------------------
draw_pixel:
    push bx
    push si
    push di

    mov bx, dx       ; y
    mov ax, bx
    shl ax, 8        ; y*256
    mov si, ax       ; store temp
    mov ax, bx
    shl ax, 6        ; y*64
    add si, ax       ; y*320
    add si, cx       ; y*320 + x
    mov di, si       ; DI = offset

    mov byte ptr es:[di], al  ; write pixel

    pop di
    pop si
    pop bx
    ret

;--------------------------------------------------
; Draw horizontal line from (startX, y) to (endX, y)
; Inputs:
;   cx = startX
;   dx = y
;   bx = endX
;   al = color
;--------------------------------------------------

draw_line_h:
    push ax
    push bx
    push cx
    push dx

draw_line_h_loop:
    mov cx, cx        ; current X
    mov dx, dx        ; Y stays constant
    mov al, al        ; color
    call draw_pixel

    inc cx
    cmp cx, bx        ; have we reached endX?
    jle draw_line_h_loop

    pop dx
    pop cx
    pop bx
    pop ax
    ret
