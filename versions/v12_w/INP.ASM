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
; INP.ASM                                                                                                                                                                                                                                                                                                                                           ; __zrppbaube_ugaiukcow_2025

.CODE

get_line_parameters:
    CALL _clear_screen

    LEA DX, prompt_line_type
    CALL PrintString
    MOV ah, 01h
    INT 21h
    MOV line_type, al

    CMP [line_type], '1'
    JE prompt_user_h
    CMP [line_type], '2'
    JE prompt_user_v
    CMP [line_type], '3'
    JE show_draw_menu_inp
    CMP [line_type], '4'
    JE _program_end_inp
    JMP get_line_parameters

_program_end_inp:
    CALL _clear_screen
    CALL _exit_program
    RET
    
show_draw_menu_inp:
    CALL show_draw_menu
    RET

prompt_for_x_y:
    CALL _clear_screen
    
    MOV dx, offset prompt_x
    MOV ah, 09h
    INT 21h
    CALL read_number                                                                                                                                                                                                                                                                                                                                           
    MOV [line_x], ax
    CALL _clear_screen

    MOV dx, offset prompt_y
    MOV ah, 09h
    INT 21h
    CALL read_number
    MOV [line_y], ax
    CALL _clear_screen   
    RET

prompt_user_h:
    CALL prompt_for_x_y

    MOV dx, offset prompt_width
    MOV ah, 09h
    INT 21h
    CALL read_number
    MOV [line_param], ax
    JMP get_color
    
prompt_user_v:
    CALL prompt_for_x_y
    
    MOV dx, offset prompt_height
    MOV ah, 09h
    INT 21h
    CALL read_number
    MOV [line_param], ax
    JMP get_color

get_color:
    CALL _clear_screen
    MOV dx, offset prompt_color
    MOV ah, 09h
    INT 21h
    CALL read_number
    MOV [line_color], al
    CALL _clear_screen
    RET                                                                                                                                                                                                                                                                                                                                           

read_number:
    MOV dx, offset input_buffer
    MOV ah, 0Ah
    INT 21h
    CALL new_line
    MOV si, offset input_buffer + 2
    XOR ax, ax

readnum_loop:
    MOV cl, [si]
    CMP cl, 13
    JE readnum_done
    SUB cl, '0'
    MOV bx, ax
    SHL ax, 1                                                                                                                                                                                                                                                                                                                                           
    SHL ax, 1
    SHL ax, 1
    ADD ax, bx
    ADD ax, bx
    ADD al, cl
    ADC ah, 0
    INC si
    JMP readnum_loop

readnum_done:
    RET

new_line:
    MOV dx, offset newl
    MOV ah, 09h
    INT 21h                                                                                                                                                                                                                                                                                                                                           
    RET