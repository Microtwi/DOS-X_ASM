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
    CALL _clear_screen
    
    CALL get_line_parameters

    CALL set_video_mode

    MOV cx, [line_x]
    MOV dx, [line_y]
    MOV al, [line_color]
    
    CALL draw_line

    MOV ah, 00h
    INT 16h

    CALL set_text_mode
    CALL show_draw_menu

draw_pixel:
    PUSH ax bx cx dx di
    
    CMP cx, 320
    JAE skip_pixel
    CMP dx, 200
    JAE skip_pixel
    
    ; CALCULATE VIDEO MEMORY OFFSET: y * 320 + x
    MOV ax, dx         ; y coordinate
    MOV bx, 320        ; screen width
    MUL bx             ; ax = y * 320
    ADD ax, cx         ; ax = y * 320 + x
    MOV di, ax         ; di = memory offset
    MOV al, [line_color]

    MOV BYTE PTR es:[di], al
    
skip_pixel:
    POP di dx cx bx ax
    RET

draw_line:
    PUSH ax bx cx dx si di

    MOV cx, [line_x]
    MOV dx, [line_y]                                                                                                                                                                                                                                                                                                                                           

    CMP line_type, '1'
    JE draw_h_loop

    CMP line_type, '2'
    JE draw_v_loop                                                                                                                                                                                                                                                                                                                                           

    POP di si dx cx bx ax
    RET

draw_h_loop:
    MOV si, cx
    MOV di, [line_param]
    ADD di, si
    
draw_h_pixel:
    CALL draw_pixel
    INC cx
    CMP cx, di
    JL draw_h_pixel
    JMP done_line

draw_v_loop:
    MOV si, dx
    MOV di, [line_param]
    ADD di, si
    
draw_v_pixel:
    CALL draw_pixel
    INC dx
    CMP dx, di
    JL draw_v_pixel                                                                                                                                                                                                                                                                                                                                           
    JMP done_line

done_line:
    POP di si dx cx bx ax
    RET
                                                                                                                                                                                                                                                                                                                                           ; __zrppbaube_ugaiukcow_2025