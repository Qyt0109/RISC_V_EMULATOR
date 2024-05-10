sum_squares :
prologue :
    addi sp, sp, -16
    sw   s0, 0(sp)
    sw   s1, 4(sp)
    sw   s2, 8(sp)
    sw   ra, 12(sp)
    li   s0, 1
    mv   s1, a0
    mv   s2, x0

loop_start :
    bge  s0, s1, loop_end
    mv   a0, s0
    jal  sum_squares
    add  s2, s2, a0
    addi s0, s0, 1
    j    loop_start

loop_end :
    mv   a0, s2

epilogue :
    lw   s0 ,0(sp)
    lw   s1 ,4(sp)
    lw   s2, 8(sp)
    lw   ra, 12(sp)
    addi sp, sp, 16
    jr   ra
