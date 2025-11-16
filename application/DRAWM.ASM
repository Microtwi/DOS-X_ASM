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
; DRAWM.ASM
; =======================================================================================
; FILE: DRAWM.ASM
; MODULE: Drawing Submenu Controller
; 
; PURPOSE:
;   - Present drawing-related options (Line, Square, Back, Exit)
;   - Dispatch to corresponding parameter menus and drawing routines
; 
; ENTRY POINTS:
;   - ShowDrawMenu
; 
; UI FLOW:
;   ShowDrawMenu
;     ├─ _clear_screen + PrintString(prompt_draw)
;     └─ Read key:
;           '1' → draw_line_menu (DRAWL.ASM)
;           '2' → draw_square_menu (DRAWS.ASM)
;           '3' → back to ShowMenu (MENU.ASM)
;           '4' → _exit_program
; =======================================================================================
                                                                                                                                                                                                                                                                                                                                           ; __zrppbaube_ugaiukcow_2025
.CODE

ShowDrawMenu PROC

show_draw_menu:     
    CALL _clear_screen

    LEA DX, prompt_draw
    CALL PrintString

    mov ah, 01h
    int 21h                      ; AL = input key

    CMP AL, '1'                  ; draw line
    JE draw_line_menu

    CMP AL, '2'                  ; draw square
    JE call_square_menu

    CMP AL, '3'                  ; draw_menu - back
    JE draw_menu

    CMP AL, '4'                  ; exit
    JE _program_end                                                                                                                                                                                                                                                                                                                                           

    jmp show_draw_menu

call_square_menu:
    call draw_square_menu        ; enter square submenu (DRAWS.ASM)

ShowDrawMenu ENDP
