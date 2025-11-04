


; draw_line_menu:
;     call set_video_mode

;     ; Draw a filled rectangle
;     mov cx, 100       ; startX
;     mov dx, 50        ; startY  
;     mov bx, 300       ; endX
;     mov si, 150       ; endY
;     mov al, 15         ; color
;     call draw_rect

;     mov ah, 00h       ; read key press
;     int 16h           ; wait for a key press

;     call set_text_mode
;     mov  ah, 4Ch      ; DOS terminate
;     int  21h

draw_rect:
    push ax bx cx dx si
    mov di, dx        ; save startY in DI

draw_rect_loop:
    mov cx, cx        ; startX
    mov dx, di        ; current Y (starts at startY)
    mov bx, bx        ; endX
    mov al, al        ; color
    call draw_line

    inc di
    cmp di, si
    jle draw_rect_loop
    
    pop si dx cx bx ax
    ret