.CODE

ShowDrawMenu PROC

    call _clear_screen
    LEA DX, prompt_draw
    CALL PrintString
    CALL NewLine

    MOV CX, 1
    MOV SI, 0

READ_DRAW_LOOP:
    JMP ReadChar
    MOV inputs[SI], AL
    CALL NewLine
    INC SI
    LOOP READ_DRAW_LOOP

    LEA DX, message
    CALL PrintString

    MOV CX, 1
    MOV SI, 0
    
PRINT_DRAW_LOOP:
    MOV DL, inputs[SI]
    CALL PrintChar
    MOV DL, ' '
    CALL PrintChar
    INC SI
    LOOP PRINT_DRAW_LOOP
    
    CALL NewLine
    RET
ShowDrawMenu ENDP