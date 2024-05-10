    li   s0, 0x01234567
    li   s1, 0x89abcdef

    addi sp, sp, 8
    sw   s0, 0(sp)
    sw   s1, 4(sp)

    li   s0, 0x00010002
    li   s1, 0x11102220

    lw   s0, 0(sp)
    lw   s1, 4(sp)
    addi sp, sp, -8