main:
main_loop:
# up time
# delay
    call delay
    nop
    nop
    j    main_loop


delay:
    li   t1, 90
delay_loop:
    bne  t1, zero, delay_loop_done
    addi t1, t1, -1

delay_loop_done:

    ret
