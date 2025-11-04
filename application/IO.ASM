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

.CODE
PrintString PROC                                                                                                                                                                                                                                                                                                                                           
    MOV AH, 09h
    INT 21h
    RET
PrintString ENDP

ReadChar:
    MOV AH, 01h
    INT 21h
    RET

PrintChar PROC
    MOV AH, 02h
    INT 21h
    RET
PrintChar ENDP

set_video_mode:                                                                                                                                                                                                                                                                                                                                           
    MOV  ah, 00h       ; BIOS set video mode
    MOV  al, 13h       ; 320x200 256 color mode
    INT  10h

    MOV ax, 0A000h     ; A000h is the segment of the video memory
    MOV es, ax         ; Load the segment into ES
    RET

set_text_mode:
    MOV  ax, 03h        ; BIOS set video mode
    MOV  bh, 00h        ; text mode
    INT  10h
    RET

_exit_program:
    CALL _clear_screen
    MOV AH, 4Ch
    INT 21h

_clear_screen:                                                                                                                                                                                                                                                                                                                                           
    MOV ax, 0600h    ; AH=06h (scroll up), AL=00h (full screen)
    MOV bh, 07h      ; Attribute (white on black)
    MOV cx, 0000h    ; Upper left corner (0,0)
    MOV dx, 184Fh    ; Lower right corner (24,79)
    INT 10h
    
    ; Set cursor position to top
    MOV ah, 02h      ; Set cursor position
    MOV bh, 00h      ; Page 0
    MOV dx, 0000h    ; Row 0, Column 0
    INT 10h
    RET

wait_for_key:
    MOV ah, 00h
    INT 16h

    CALL set_text_mode
    RET

                                                                                                                                                                                                                                                                                                                                           ; __zrppbaube_ugaiukcow_2025