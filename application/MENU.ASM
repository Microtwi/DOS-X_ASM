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
; MENU.ASM
; =======================================================================================
; FILE: MENU.ASM
; MODULE: Main Menu (Text UI)
; 
; PURPOSE:
;   - Present main options to the user (Draw, About/Credits, Exit)
;   - Dispatch to drawing submenu or terminate program
; 
; PERIPHERALS AND SERVICES:
;   - Display (INT 10h via IO.ASM for clear)
;   - Keyboard input via DOS (INT 21h/AH=01h)
;   - DOS output (INT 21h/AH=09h) through PrintString
; 
; ENTRY POINTS:
;   - ShowMenu
; 
; UI FLOW:
;   ShowMenu
;     ├─ _clear_screen
;     ├─ PrintString(prompt_menu)
;     └─ Read key (INT 21h/01h) → route:
;           '1' → ShowDrawMenu (DRAWM.ASM)
;           '2' → Credits screen
;           '3' → Exit program
; =======================================================================================

ShowMenu PROC

draw_menu:

    CALL _clear_screen           ; ensure a clean text screen
    LEA DX, prompt_menu
    CALL PrintString             ; display main menu

    MOV ah, 01h                  ; read single character from STDIN (echo)
    INT 21h                      ; AL = ASCII

    CMP AL, '1'
    JE show_draw_menu            ; draw menu

    CMP AL, '2'                  ; credits
    JE _draw_credit

    CMP AL, '3'                  ; exit
    JE _program_end

    JMP draw_menu                ; loop back to menu

_draw_credit:
    CALL _clear_screen
    LEA DX, logo                 ; simple credits / about block
    CALL PrintString

    MOV ah, 01h                  ; wait for any key
    INT 21h

    JMP draw_menu

_program_end:
    CALL _clear_screen
    CALL _exit_program           ; graceful exit (IO.ASM)

ShowMenu ENDP
