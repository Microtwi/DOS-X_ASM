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
; IO.ASM
; =======================================================================================
; FILE: IO.ASM
; MODULE: I/O Utilities and System Services
; 
; PURPOSE:
;   - Wrap DOS and BIOS services used across the application
;   - Provide screen management, mode switching, and simple I/O helpers
; 
; SERVICES:
;   - PrintString: DOS AH=09h, DS:DX points to '$'-terminated string
;   - ReadChar:    DOS AH=01h, returns AL
;   - PrintChar:   DOS AH=02h, DL = char
;   - set_video_mode: BIOS 13h 320x200x256, sets ES=A000h
;   - set_text_mode:  BIOS 03h, standard 80x25 text
;   - _clear_screen:  BIOS scroll to clear and reset cursor
;   - wait_for_key:   BIOS INT 16h, then restore text mode
;   - _exit_program:  DOS terminate (AH=4Ch)
; =======================================================================================

.CODE
PrintString PROC
    MOV AH, 09h
    INT 21h
    RET
PrintString ENDP

ReadChar:
    MOV AH, 01h           ; read char with echo
    INT 21h               ; AL result
    RET

PrintChar PROC
    MOV AH, 02h           ; DL = char to print
    INT 21h
    RET
PrintChar ENDP

set_video_mode:
    MOV  ah, 00h         ; BIOS set video mode
    MOV  al, 13h         ; 320x200 256 color mode
    INT  10h

    MOV ax, 0A000h       ; A000h is the segment of the video memory
    MOV es, ax           ; Load the segment into ES
    RET

set_text_mode:
    MOV  ax, 03h         ; BIOS set video mode (80x25 text)
    MOV  bh, 00h
    INT  10h
    RET

_exit_program:
    CALL _clear_screen
    MOV AH, 4Ch          ; DOS terminate
    INT 21h

_clear_screen:
    MOV ax, 0600h        ; AH=06h (scroll up), AL=00h (full screen)
    MOV bh, 07h          ; Attribute (white on black)
    MOV cx, 0000h        ; Upper left corner (0,0)
    MOV dx, 184Fh        ; Lower right corner (24,79)
    INT 10h
    
    ; Set cursor position to top-left
    MOV ah, 02h
    MOV bh, 00h
    MOV dx, 0000h       ; Row 0, Column 0
    INT 10h
    RET

wait_for_key:
    MOV ah, 00h         ; BIOS keyboard: wait for key
    INT 16h

    CALL set_text_mode
    RET

                                                                                                                                                                                                                                                                                                                                           ; __zrppbaube_ugaiukcow_2025