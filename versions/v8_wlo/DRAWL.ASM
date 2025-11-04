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
; DRAWL.ASM

draw_line_menu:
    call _clear_screen
    call get_line_parameters
    jc draw_line_menu_error
    call set_video_mode
    mov cx, [line_x]
    mov dx, [line_y]
    mov bx, [line_width]
    add bx, cx
    cmp bx, MAX_X
    jle line_ok1
    mov bx, MAX_X
line_ok1:
    mov al, [line_color]
    call draw_line_h
    xor ah, ah
    int 16h
    call set_text_mode
    jmp draw_menu

draw_line_menu_error:
    mov ah, 09h
    int 21h
    xor ah, ah
    int 16h
    jmp draw_line_menu

get_line_parameters:
    mov dx, offset prompt_x
    mov ah, 09h
    int 21h
    call read_number
    jc invalid_number
    cmp ax, MAX_X
    ja range_x
    mov [line_x], ax
    call _clear_screen

    mov dx, offset prompt_y
    mov ah, 09h
    int 21h
    call read_number
    jc invalid_number
    cmp ax, MAX_Y
    ja range_y
    mov [line_y], ax
    call _clear_screen

    mov dx, offset prompt_width
    mov ah, 09h
    int 21h
    call read_number
    jc invalid_number
    cmp ax, 0
    jg width_ok1
    mov ax, 1

width_ok1:
    mov bx, MAX_X
    sub bx, [line_x]
    cmp ax, bx
    jle width_ok2
    mov dx, offset error_width_range
    mov ah, 09h
    int 21h
    mov ax, bx
    call display_number
    call new_line
    stc
    ret
    
width_ok2:
    mov [line_width], ax
    call _clear_screen

    mov dx, offset prompt_color
    mov ah, 09h
    int 21h
    call read_number
    jc invalid_number
    cmp al, MAX_COLOR
    ja range_color
    mov [line_color], al
    call _clear_screen
    clc
    ret

invalid_number:
    mov dx, offset error_invalid_number
    stc
    ret
range_x:
    mov dx, offset error_x_range
    stc
    ret
range_y:
    mov dx, offset error_y_range
    stc
    ret
range_color:
    mov dx, offset error_color_range
    stc
    ret

read_number:
    mov dx, offset input_buffer
    mov ah, 0Ah
    int 21h
    call new_line
    mov si, offset input_buffer + 1
    mov cl, [si]
    or cl, cl
    jz readnum_invalid
    mov si, offset input_buffer + 2
    xor ax, ax

readnum_loop:
    mov cl, [si]
    cmp cl, 13
    je readnum_done
    sub cl, '0'
    jb readnum_invalid
    cmp cl, 9
    ja readnum_invalid
    mov bx, ax
    shl ax, 1
    shl ax, 1
    shl ax, 1
    add ax, bx
    add ax, bx
    add al, cl
    adc ah, 0
    inc si
    jmp readnum_loop

readnum_done:
    clc
    ret
    
readnum_invalid:
    stc
    ret

display_number:
    push ax bx cx dx
    mov bx, 10
    xor cx, cx
disp_loop1:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz disp_loop1
disp_loop2:
    pop ax
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    loop disp_loop2
    pop dx cx bx ax
    ret

new_line:
    mov dx, offset newl
    mov ah, 09h
    int 21h
    ret

set_video_mode:
    mov ax, 0013h
    int 10h
    mov ax, 0A000h
    mov es, ax
    ret

set_text_mode:
    mov ax, 0003h
    int 10h
    ret

draw_pixel:
    cmp cx, 0
    jl pix_skip
    cmp cx, MAX_X
    jg pix_skip
    cmp dx, 0
    jl pix_skip
    cmp dx, MAX_Y
    jg pix_skip
    push bx si di
    mov ax, dx
    shl ax, 8
    mov si, ax
    mov ax, dx
    shl ax, 6
    add si, ax
    add si, cx
    mov di, si
    mov es:[di], al
    pop di si bx
pix_skip:
    ret

draw_line_h:
    push ax bx cx dx
    cmp cx, 0
    jge line_start_ok
    xor cx, cx
line_start_ok:
    cmp bx, MAX_X
    jle line_end_ok
    mov bx, MAX_X
line_end_ok:
line_h_loop:
    call draw_pixel
    inc cx
    cmp cx, bx
    jle line_h_loop
    pop dx cx bx ax
    ret