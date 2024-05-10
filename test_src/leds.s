loop:
    li    a0, 0x121
    li    a1, 0b01
    ecall
    nop

    li    a0, 0x121
    li    a1, 0b10
    ecall
    nop
    
    j     loop