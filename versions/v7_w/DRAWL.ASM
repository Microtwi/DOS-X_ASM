draw_line_menu:
    call _clear_screen
    
    call get_line_parameters
    call set_video_mode

    mov cx, line_x        ; startX
    mov dx, line_y        ; Y coordinate
    mov bx, line_width    ; endX = startX + width
    add bx, cx            ; bx = startX + width
    mov al, line_color    ; color
    
    call draw_line_h
    
    mov ah, 00h
    int 16h
    
    call set_text_mode
    jmp draw_menu

get_line_parameters:
    ; Get X coordinate
    mov dx, offset prompt_x
    mov ah, 09h
    int 21h
    call read_number
    mov line_x, ax
    call _clear_screen

    ; Get Y coordinate  
    mov dx, offset prompt_y
    mov ah, 09h
    int 21h
    call read_number
    mov line_y, ax
    call _clear_screen

    ; Get width
    mov dx, offset prompt_width
    mov ah, 09h
    int 21h
    call read_number
    mov line_width, ax
    call _clear_screen

    ; Get color
    mov dx, offset prompt_color
    mov ah, 09h
    int 21h
    call read_number
    mov line_color, al
    call _clear_screen

    ret

read_number:
    mov dx, offset input_buffer
    mov ah, 0Ah           ; buffered input
    int 21h
    
    ; Print newline
    mov dx, offset newl
    mov ah, 09h
    int 21h
    
    ; Convert string to number
    mov si, offset input_buffer + 2  ; point to input data
    xor ax, ax            ; clear AX
    mov bx, 10            ; base 10
    
convert_loop:
    mov cl, [si]          ; get character
    cmp cl, 13            ; check for carriage return
    je convert_done
    cmp cl, '0'           ; validate digit
    jb convert_done
    cmp cl, '9'
    ja convert_done
    
    sub cl, '0'           ; convert ASCII to number
    mul bx                ; AX = AX * 10
    add al, cl            ; add new digit
    adc ah, 0             ; handle carry
    inc si
    jmp convert_loop
    
convert_done:
    ret

set_video_mode:
    mov ah, 00h
    mov al, 13h
    int 10h
    mov ax, 0A000h
    mov es, ax
    ret

set_text_mode:
    mov ax, 03h
    mov bh, 00h
    int 10h
    ret

draw_pixel:
    push bx
    push si
    push di
    mov bx, dx
    mov ax, bx
    shl ax, 8
    mov si, ax
    mov ax, bx
    shl ax, 6
    add si, ax
    add si, cx
    mov di, si
    mov byte ptr es:[di], al
    pop di
    pop si
    pop bx
    ret

draw_line_h:
    push ax
    push bx
    push cx
    push dx
draw_line_h_loop:
    call draw_pixel
    inc cx
    cmp cx, bx
    jle draw_line_h_loop
    pop dx
    pop cx
    pop bx
    pop ax
    ret