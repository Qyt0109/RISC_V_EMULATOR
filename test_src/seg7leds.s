led:
    li    a0, 0x120
    li    a1, 0b0110011001011011
    li    a2, 0b1111111111111111
    ecall
    nop

    li    a0, 0x120
    li    a1, 0b0000000000000100
    li    a2, 0b0000000000010100
    ecall
    nop

    j     led
    nop