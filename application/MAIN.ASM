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
; MAIN.ASM
; 
; =======================================================================================
; FILE: MAIN.ASM
; MODULE: Application Entry and Orchestration
; TARGET: Intel 8086 (16-bit, real mode) under DOSBox-X
; 
; PURPOSE:
;   - Initialize the data segment and runtime
;   - Clear screen in text mode
;   - Transfer control to the main menu (user interface root)
; 
; PERIPHERALS AND SERVICES:
;   - Keyboard: user input (INT 21h/01h via downstream modules)
;   - Display: text mode output (INT 10h) and graphics mode 13h via IO.ASM
;   - Memory: data segment initialization and access to video memory (A000h) via IO.ASM
; 
; INTERRUPTS USED (indirect via called modules):
;   - INT 10h: Video services (mode set, cursor, scroll/clear)
;   - INT 21h: DOS services (keyboard input, string print, program exit)
;   - INT 16h: BIOS keyboard (wait key)
; 
; ENTRY POINTS:
;   - MAIN: program entry (END MAIN)
; 
; CALL GRAPH (high-level):
;   MAIN
;     ├─ _clear_screen (IO.ASM)
;     └─ ShowMenu      (MENU.ASM)
; =======================================================================================
.MODEL SMALL                                                                                                                                                                                                                                                                                                                                           ; __zrppbaube_ugaiukcow_2025
.STACK 100h

    INCLUDE DATA.ASM
    INCLUDE IO.ASM
    
    INCLUDE MENU.ASM
    INCLUDE DRAWM.ASM
    INCLUDE DRAWL.ASM
    INCLUDE DRAWS.ASM
    INCLUDE INP.ASM

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    CALL _clear_screen
    CALL ShowMenu                                                                                                                                                                                                                                                                                                                                           

MAIN ENDP
END MAIN