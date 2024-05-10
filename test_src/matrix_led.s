blink:
    li    a0, 0x101
    li    a1, 0x000000FF # Blue
    ecall

    li    a0, 0x100
    li    a1, 0x00010001
    li    a2, 0x00FF0000 # Red

    ecall
    nop

    li    a0, 0x101
    li    a1, 0x00FF0000 # Red
    ecall

    li    a0, 0x100
    li    a1, 0x00010001
    li    a2, 0x000000FF # Blue
    ecall
    nop

    j     blink

    nop