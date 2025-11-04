draw_line_menu:
    call _clear_screen
    call get_line_parameters
    jc draw_line_menu_error    ; If carry flag set, there was an error
    
    call set_video_mode

    ; Set up parameters for draw_line_h with bounds checking
    mov cx, [line_x]           ; startX
    mov dx, [line_y]           ; Y coordinate
    
    ; Calculate endX = startX + width, ensure it doesn't exceed MAX_X
    mov bx, [line_width]       ; width
    add bx, cx                 ; bx = startX + width
    cmp bx, MAX_X
    jle .line_width_ok
    mov bx, MAX_X              ; clamp to maximum X
.line_width_ok:
    
    mov al, [line_color]       ; color
    
    call draw_line_h
    
    mov ah, 00h
    int 16h
    
    call set_text_mode
    jmp draw_menu

draw_line_menu_error:

    mov ah, 09h
    int 21h
    
    mov ah, 00h
    int 16h
    jmp draw_line_menu

get_line_parameters:

.get_line_x:

    mov dx, offset prompt_x
    mov ah, 09h
    int 21h
    call read_number
    jc .get_line_invalid_number
    
    cmp ax, MAX_X
    jle .get_line_x_ok
    mov dx, offset error_x_range
    stc                         ; set carry flag for error
    ret
.get_line_x_ok:

    mov [line_x], ax
    call _clear_screen

.get_line_y:

    mov dx, offset prompt_y
    mov ah, 09h
    int 21h
    call read_number
    jc .get_line_invalid_number
    
    cmp ax, MAX_Y
    jle .get_line_y_ok
    mov dx, offset error_y_range
    stc
    ret
.get_line_y_ok:

    mov [line_y], ax
    call _clear_screen

.get_line_width:

    mov dx, offset prompt_width
    mov ah, 09h
    int 21h
    call read_number
    jc .get_line_invalid_number
    
    cmp ax, 0
    jg .get_line_width_positive
    mov ax, 1

.get_line_width_positive:
    
    mov bx, MAX_X
    sub bx, [line_x]
    cmp ax, bx
    jle .get_line_width_ok
    
    mov dx, offset error_width_range
    mov ah, 09h
    int 21h
    
    mov ax, bx
    call display_number
    call new_line
    
    stc
    ret
.get_line_width_ok:

    mov [line_width], ax
    call _clear_screen

.get_line_color:

    mov dx, offset prompt_color
    mov ah, 09h
    int 21h
    call read_number
    jc .get_line_invalid_number
    
    cmp al, MAX_COLOR
    jle .get_line_color_ok
    mov dx, offset error_color_range
    stc
    ret

.get_line_color_ok:

    mov [line_color], al
    call _clear_screen
    
    clc                         ; clear carry flag for success
    ret

.get_line_invalid_number:

    mov dx, offset error_invalid_number
    stc
    ret

read_number:

    mov dx, offset input_buffer
    mov ah, 0Ah
    int 21h
    
    call new_line
    
    mov si, offset input_buffer + 1
    mov cl, [si]
    cmp cl, 0
    je .read_number_invalid
    
    mov si, offset input_buffer + 2
    xor ax, ax
    mov bx, 10
    
.read_number_loop:

    mov cl, [si]
    cmp cl, 13
    je .read_number_done
    cmp cl, '0'
    jb .read_number_invalid
    cmp cl, '9'
    ja .read_number_invalid
    
    sub cl, '0'

    push bx
    mov bx, ax
    shl ax, 1                   ; ax * 2
    jc .read_number_overflow
    shl ax, 1                   ; ax * 4
    jc .read_number_overflow
    shl ax, 1                   ; ax * 8
    jc .read_number_overflow
    add ax, bx                  ; ax * 9
    jc .read_number_overflow
    add ax, bx                  ; ax * 10
    jc .read_number_overflow
    pop bx
    
    add al, cl
    adc ah, 0
    jc .read_number_overflow
    
    inc si
    jmp .read_number_loop

.read_number_done:

    clc
    ret

.read_number_overflow:

    pop bx

.read_number_invalid:

    stc
    ret

display_number:

    push ax
    push bx
    push cx
    push dx
    
    mov bx, 10
    xor cx, cx
    
.display_num_loop:

    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz .display_num_loop
    
.display_num_print:

    pop ax
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    loop .display_num_print
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret

new_line:

    mov dx, offset newl
    mov ah, 09h
    int 21h
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

    cmp cx, 0
    jl .draw_pixel_skip
    cmp cx, MAX_X
    jg .draw_pixel_skip
    cmp dx, 0
    jl .draw_pixel_skip
    cmp dx, MAX_Y
    jg .draw_pixel_skip
    
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

.draw_pixel_skip:

    ret

draw_line_h:

    push ax
    push bx
    push cx
    push dx
    
    cmp cx, 0
    jge .draw_line_start_ok
    mov cx, 0

.draw_line_start_ok:
    
    cmp bx, MAX_X
    jle .draw_line_end_ok
    mov bx, MAX_X

.draw_line_end_ok:
    
.draw_line_h_loop:

    call draw_pixel
    inc cx
    cmp cx, bx
    jle .draw_line_h_loop
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret