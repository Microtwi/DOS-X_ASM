draw_line_menu:
    CALL _clear_screen
    
    LEA DX, prompt_line_type
    CALL PrintString

    MOV ah, 01h
    INT 21h
    MOV line_type, al

    MOV cx, 100
    MOV dx, 101
    MOV bx, 200
    MOV al, 3
    MOV line_color, al

    CALL set_video_mode
    CALL draw_line

    MOV ah, 00h
    INT 16h

    CALL set_text_mode
    MOV  ah, 4Ch
    INT  21h

draw_pixel:
    PUSH bx si di

    MOV bx, dx
    MOV si, bx
    SHL si, 8
    MOV di, bx
    SHL di, 6
    ADD si, di
    ADD si, cx
    MOV di, si
    MOV BYTE PTR es:[di], al

    POP di si bx
    RET

draw_line:
    PUSH ax bx cx dx

    MOV al, line_color

    CMP line_type, '1'
    JE draw_h_loop

    CMP line_type, '2'
    JE draw_v_loop

    POP dx cx bx ax
    RET

draw_h_loop:
    CALL draw_pixel
    INC cx
    CMP cx, bx
    JLE draw_h_loop
    JMP done_line

draw_v_loop:
    CALL draw_pixel
    INC dx
    CMP dx, bx
    JLE draw_v_loop
    JMP done_line

done_line:
    POP dx cx bx ax
    RET