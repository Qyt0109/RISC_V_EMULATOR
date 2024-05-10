#define SEC, s2
#define MIN, s3
#define HOUR, s4
#define DAY, s5
#define MONTH, s6
#define YEAR, s7

    .data
MSG_CURRENT_DATETIME:
    .string "\nCurrent datetime "

    .equ    ARRAY_31_DAYS_MONTHS_ELEMENT_WIDTH, 1
ARRAY_31_DAYS_MONTHS:
    .byte   1, 3, 5, 7, 8, 10, 12, '\n'

    .text
# region main
main:
# init address for stack's top
    li      sp, 0x80000000

    call    init_time_test3
main_loop:
    nop
    call    print_time
    call    up_time
    j       main_loop
# endregion main

init_time_test1:
# 29/2/2024 23-59-59
    li      SEC, 59
    li      MIN, 59
    li      HOUR, 23
    li      DAY, 29
    li      MONTH, 2
    li      YEAR, 2024
    ret

init_time_test2:
# 31 days month
# 31/3/2024 23-59-59
    li      SEC, 59
    li      MIN, 59
    li      HOUR, 23
    li      DAY, 31
    li      MONTH, 3
    li      YEAR, 2024
    ret

init_time_test3:
# 30 days month
# 30/4/2024 23-59-59
    li      SEC, 59
    li      MIN, 59
    li      HOUR, 23
    li      DAY, 30
    li      MONTH, 4
    li      YEAR, 2024
    ret

init_time_test4:
# end of year
# 29/4/2024 23-59-59
    li      SEC, 59
    li      MIN, 59
    li      HOUR, 23
    li      DAY, 31
    li      MONTH, 12
    li      YEAR, 2024
    ret

display_seg7led:
#

    ret

up_time:
# FIXME: REMOVE THIS TEST ONLY
# j force_uptime_day
# FIXME: REMOVE THIS TEST ONLY
    nop
    li      t0, 60                                 # temp register to hold value for comparison

# up_time_sec:
    addi    SEC, SEC, 1
    blt     SEC, t0, no_update

# up_time_min:
    li      SEC, 0
    addi    MIN, MIN, 1
    blt     MIN, t0, no_update

    li      t0, 24                                 # temp register to hold value for comparison

# up_time_hour:
    li      MIN, 0
    addi    HOUR, HOUR, 1
    blt     HOUR, t0, no_update

# FIXME: REMOVE THIS TEST ONLY
force_uptime_day:
# FIXME: REMOVE THIS TEST ONLY

# up_time_day:
    li      HOUR, 0
    addi    DAY, DAY, 1

# push current return address (ra)
    addi    sp, sp, 2                              # Add 32 bit volume space in stack
    sw      ra, 0(sp)                              # Store doubleword (32 bit)

# call function get_last_day_of_month. a0 = get_last_day_of_month()
    call    get_last_day_of_month

# pop stored return address (ra)
    lw      ra, 0(sp)                              # Load doubleword (32 bit)
    addi    sp, sp, -2                             # Remove 32 bit volume space in stack

    ble     DAY, a0, no_update

    li      t0, 12                                 # temp register to hold value for comparison

# update_time_month:
    li      DAY, 1
    addi    MONTH, MONTH, 1
    bne     MONTH, t0, no_update

# update_time_year
    li      MONTH, 1
    addi    YEAR, YEAR, 1

no_update:
    ret


# region get_last_day_of_month
get_last_day_of_month:
# Return a0 = last day of month
# First check if MONTH == 2, then check YEAR % 4 (2 lsb == 00) => leap year, a0 = 1 else a0 = 0. Last day of MONTH 2 = 28 + a0.

# check_month_2:
    li      t0, 2
    bne     MONTH, t0, month_not_2                 # if MONTH != 2
# check_month_2_true:
    li      a0, 28                                 # assum last day of month a0 = 28
# check_leap_year:
    andi    t0, YEAR, 0x3                          # Check 2 lsb
    bnez    t0, get_last_day_of_month_done         # 2 lsb != 00 => not a leap year, keep a0 = 28 value and return
# check_leap_year_true:
    li      a0, 29                                 # else => leap year, update a0 = 29
    j       get_last_day_of_month_done             # then return

month_not_2:
# check month 1, 3, 5, 7, 8, 10, 12 => last day of month a0 = 31
# check_month_31_days:
    li      a0, 30                                 # assum not 31 days month
    li      t0, ARRAY_31_DAYS_MONTHS_ELEMENT_WIDTH # element size = 1 (byte)
    la      t1, ARRAY_31_DAYS_MONTHS               # byte *t1 = ARRAY_31_DAYS_MONTHS;
    li      t3, '\n'                               # end of the array
check_month_31_days_loop:
    lb      t2, 0(t1)                              # t2 = array[t1]
    beq     t2, t3, get_last_day_of_month_done     # Check all elements, not match => 30 days month
    beq     MONTH, t2, check_month_31_days_true
# check_month_31_days_loop_false:
    add     t1, t1, t0                             # Point to next element. *t1 = *(t1 + t0)
    j       check_month_31_days_loop

check_month_31_days_true:
    li      a0, 31                                 # MONTH == (1 of the element in 31 days month array)
# check_month_31_days_done:

get_last_day_of_month_done:
    ret
# endregion get_last_day_of_month



# region print_time
print_time:
    li      a0, 4                                  # print string
    la      a1, MSG_CURRENT_DATETIME
    ecall

    li      a0, 1                                  # print int
    mv      a1, s5
    ecall

    li      a0, 11                                 # print char
    li      a1, '/'
    ecall

    li      a0, 1                                  # print int
    mv      a1, s6
    ecall

    li      a0, 11                                 # print char
    li      a1, '/'
    ecall

    li      a0, 1                                  # print int
    mv      a1, s7
    ecall

    li      a0, 11                                 # print char
    li      a1, ' '
    ecall

    li      a0, 1                                  # print int
    mv      a1, s4
    ecall

    li      a0, 11                                 # print char
    li      a1, '-'
    ecall

    li      a0, 1                                  # print int
    mv      a1, s3
    ecall

    li      a0, 11                                 # print char
    li      a1, '-'
    ecall

    li      a0, 1                                  # print int
    mv      a1, s2
    ecall

    ret
# endregion print_time