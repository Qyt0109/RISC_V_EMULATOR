#define SEC

main:


up_time:
# up_time_sec:
    addi s0, s0, 1
    bne  s0, 60, no_update
# up_time_min:
    li   SEC, 0
    addi MIN, MIN, 1
    bne MIN, 60, no_update
# up_time_hour:
    li MIN, 0
    addi HOUR, HOUR, 1
    bne HOUR, 24, no_update
# up_time_day:
    li HOUR, 0
    addi DAY, DAY, 1
no_update:
    ret
    

