    li    a0, 0x120
    li    a1, 0b0110011001011011
    li    a2, 0b1111111111111111
    ecall
loop:
    li    a0, 0x122
    ecall
    andi  x1, a0, 0x1
    add   x2, x2, x1
    andi  x3, a0, 0x2
    add   x4, x4, x3
    mv    a1, a0
    li    a0, 0x121
    ecall
    j     loop