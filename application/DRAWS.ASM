; ▀████    ▐████▀ ████████▄     ▄████████    ▄████████    ▄█   ▄█▄    ▄████████  ▄██████▄  ███    █▄   ▄█                                                                                                                                                                       __zrppbaube_ugaiukcow_2025
;   ███▌   ████▀  ███   ▀███   ███    ███   ███    ███   ███ ▄███▀   ███    ███ ███    ███ ███    ███ ███       
;    ███  ▐███    ███    ███   ███    ███   ███    ███   ███▐██▀     ███    █▀  ███    ███ ███    ███ ███       
;    ▀███▄███▀    ███    ███   ███    ███  ▄███▄▄▄▄██▀  ▄█████▀      ███        ███    ███ ███    ███ ███       
;    ████▀██▄     ███    ███ ▀███████████ ▀▀███▀▀▀▀▀   ▀▀█████▄    ▀███████████ ███    ███ ███    ███ ███       
;   ▐███  ▀███    ███    ███   ███    ███ ▀███████████   ███▐██▄            ███ ███    ███ ███    ███ ███       
;  ▄███     ███▄  ███   ▄███   ███    ███   ███    ███   ███ ▀███▄    ▄█    ███ ███    ███ ███    ███ ███▌    ▄ 
; ████       ███▄ ████████▀    ███    █▀    ███    ███   ███   ▀█▀  ▄████████▀   ▀██████▀  ████████▀  █████▄▄██     
;                                                                                                                                                                                                                                                                                                                                           ; __zrppbaube_ugaiukcow_2025
;  _   _      _                _ _        _              _____                 _ _               _           _ _        ___                      
; | | | |_ _ (_)_ _____ _ _ __(_) |_ __ _| |_ ___ __ _  |_   _| _ __ _ _ _  __(_) |_ ____ _ _ _ (_)__ _   __| (_)_ _   | _ )_ _ __ _ ___ _____ __
; | |_| | ' \| \ V / -_) '_(_-< |  _/ _` |  _/ -_) _` |   | || '_/ _` | ' \(_-< | \ V / _` | ' \| / _` | / _` | | ' \  | _ \ '_/ _` (_-</ _ \ V /
;  \___/|_||_|_|\_/\___|_| /__/_|\__\__,_|\__\___\__,_|   |_||_| \__,_|_||_/__/_|_|\_/\__,_|_||_|_\__,_| \__,_|_|_||_| |___/_| \__,_/__/\___/\_/ 
; DRAWS.ASM
; =======================================================================================
; FILE: DRAWS.ASM
; MODULE: Square Drawing Menu + Algorithms
; 
; PURPOSE:
;   - Present square drawing options (filled or outline)
;   - Collect parameters and draw using line primitives (from DRAWL.ASM)
; 
; ENTRY POINTS:
;   - draw_square_menu
;   - draw_square (filled)
;   - draw_square_outline
; =======================================================================================

.CODE                                                                                                                                                                                                                                                                                                                                           ; __zrppbaube_ugaiukcow_2025

draw_square_menu:                                                                                                                                                                                                                                                                                                                              
    CALL _clear_screen
    LEA DX, prompt_square
    CALL PrintString
    
    MOV ah, 01h                    ; read user selection
    INT 21h

    CMP AL, '1'                  ; draw filled square
    JE prepare_filled_square
    CMP AL, '2'                  ; draw outline square
    JE prepare_outline_square
    CMP AL, '3'                  ; draw_menu back
    JE _show_draw_menu_sqr                                                                                                                                                                                                                                                                                                                              
    CMP AL, '4'                  ;  exit
    JE _program_end_sqr

    JMP draw_square_menu

prepare_filled_square:
    CALL sqr_user_input            
    CALL _clear_screen
    CALL set_video_mode
    CALL draw_square               ; filled square

prepare_outline_square:
    CALL sqr_user_input
    CALL _clear_screen
    CALL set_video_mode
    CALL draw_square_outline

_show_draw_menu_sqr:
    CALL show_draw_menu                                                                                                                                                                                                                                                                                                                               ; __zrppbaube_ugaiukcow_2025                                                                                                                                                                                                                                                                                                                                         ; __zrppbaube_ugaiukcow_2025
    RET
    
_program_end_sqr:
    CALL _clear_screen
    CALL _exit_program
    RET

draw_square:
    ; Draw a filled square at (square_x, square_y) with side = square_size
    PUSH ax bx cx dx si di
    
    MOV ax, [square_x]
    MOV bx, [square_y]
    MOV cx, [square_size]
    
    MOV si, bx
    MOV di, bx                                                                                                                                                                                                                                                                                                                              
    ADD di, cx
    
draw_square_loop:
    MOV [line_x], ax
    MOV [line_y], si
    MOV [line_param], cx
    MOV [line_type], '1'   ; horizontal line
    MOV dl, [square_color]
    MOV [line_color], dl
    
    CALL draw_line
    
    INC si
    CMP si, di
    JL draw_square_loop
    
    POP di si dx cx bx ax
    CALL wait_for_key
    JMP show_draw_menu
    
draw_square_outline:
    ; Draw only the 4 borders (top, bottom, left, right)
    PUSH ax bx cx dx
    
    MOV ax, [square_x]
    MOV bx, [square_y]
    MOV cx, [square_size]
    MOV dl, [square_color]
    
    MOV [line_x], ax
    MOV [line_y], bx
    MOV [line_param], cx
    MOV [line_type], '1'
    MOV [line_color], dl
    CALL draw_line                ; top
    
    MOV [line_x], ax
    MOV dx, bx
    ADD dx, cx
    DEC dx
    MOV [line_y], dx
    MOV [line_param], cx                                                                                                                                                                                                                                                                                                                              
    MOV [line_type], '1'
    CALL draw_line                ; bottom
    
    MOV [line_x], ax
    MOV [line_y], bx
    MOV [line_param], cx
    MOV [line_type], '2'
    CALL draw_line                ; left

    MOV dx, ax
    ADD dx, cx
    DEC dx
    MOV [line_x], dx
    MOV [line_y], bx
    MOV [line_param], cx
    MOV [line_type], '2'
    CALL draw_line                ; right

    POP dx cx bx ax
    CALL wait_for_key
    JMP show_draw_menu

sqr_user_input:
    CALL _clear_screen
    
    MOV dx, OFFSET prompt_square_x
    CALL PrintString
    CALL read_number
    MOV [square_x], ax
    CALL _clear_screen
 
    MOV dx, OFFSET prompt_square_y                                                                                                                                                                                                                                                                                                                              
    CALL PrintString
    CALL read_number
    MOV [square_y], ax
    CALL _clear_screen

    MOV dx, OFFSET prompt_square_size
    CALL PrintString
    CALL read_number
    MOV [square_size], ax
    CALL _clear_screen

    MOV dx, OFFSET prompt_square_color
    CALL PrintString
    CALL read_number
    MOV [square_color], al
    CALL _clear_screen
    RET                                                                                                                                                                                                                                                                                                                                                        
