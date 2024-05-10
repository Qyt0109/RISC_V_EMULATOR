#define ECALL_CODE, a0

#define DISPLAY_ALL_PIXELS_COLOR, a1

# Display pixel func's agrs
#define DISPLAY_PIXEL_CODE_INDEX, a3
#define DISPLAY_PIXEL_POSITION_Y, a5
#define DISPLAY_PIXEL_POSITION_X, a4

# Display pixel func's local vars
#define DISPLAY_PIXEL_YX, a1
#define DISPLAY_PIXEL_COLOR, a2

    .equ  DISPLAY_ALL_PIXELS, 0x101
    .equ  DISPLAY_PIXEL, 0x100

    .equ  HEX_BITS, 4

# Time
#define SEC, s2
#define MIN, s3
#define HOUR, s4
#define DAY, s5
#define MONTH, s6
#define YEAR, s7

# Datetime X
    .equ  TIME_BLOCK_X, 1
    .equ  DATE_BLOCK_X, 3

# Datetime Y
# Time
    .equ  SEC1_BLOCK_Y, 7
    .equ  SEC0_BLOCK_Y, 8

    .equ  MIN1_BLOCK_Y, 4
    .equ  MIN0_BLOCK_Y, 5

    .equ  HOUR1_BLOCK_Y, 1
    .equ  HOUR0_BLOCK_Y, 2

# Date
    .equ  DAY1_BLOCK_Y, 0
    .equ  DAY0_BLOCK_Y, 1

    .equ  MONTH1_BLOCK_Y, 3
    .equ  MONTH0_BLOCK_Y, 4

    .equ  YEAR3_BLOCK_Y, 6
    .equ  YEAR2_BLOCK_Y, 7
    .equ  YEAR1_BLOCK_Y, 8
    .equ  YEAR0_BLOCK_Y, 9

# FSM
#define BUTTON_0, s10
#define BUTTON_1, s11

# PLAY/PAUSE
    .equ  PLAY_PAUSE_BLOCK_Y, 0
    .equ  PLAY_PAUSE_BLOCK_X, 0
    .equ  PLAY_CODE, 1
    .equ  PAUSE_CODE, 0

#define FSM_STATE, s9
    .equ  FSM_STATE_UP_TIME, 0x00
    .equ  FSM_STATE_CHANGE_SEC, 0x01
    .equ  FSM_STATE_CHANGE_MIN, 0x02
    .equ  FSM_STATE_CHANGE_HOUR, 0x03
    .equ  FSM_STATE_CHANGE_DAY, 0x04
    .equ  FSM_STATE_CHANGE_MONTH, 0x05
    .equ  FSM_STATE_CHANGE_YEAR, 0x06

    .equ  BUTTON_0_MASK 0x01
    .equ  BUTTON_1_MASK 0x02

    .data
ARRAY_CHAR_CODES:
# 0x3c66666e76663c00 # 0
# 0x7e1818181c181800 # 1
# 0x7e060c3060663c00 # 2
# 0x3c66603860663c00 # 3
# 0x30307e3234383000 # 4
# 0x3c6660603e067e00 # 5
# 0x3c66663e06663c00 # 6
# 0x1818183030667e00 # 7
# 0x3c66663c66663c00 # 8
# 0x3c66607c66663c00 # 9

NUM0:
    .byte 0x00, 0x3c, 0x66, 0x76, 0x6e, 0x66, 0x66, 0x3c

NUM1:
    .byte 0x00, 0x18, 0x18, 0x1c, 0x18, 0x18, 0x18, 0x7e

NUM2:
    .byte 0x00, 0x3c, 0x66, 0x60, 0x30, 0x0c, 0x06, 0x7e

NUM3:
    .byte 0x00, 0x3c, 0x66, 0x60, 0x38, 0x60, 0x66, 0x3c

NUM4:
    .byte 0x00, 0x30, 0x38, 0x34, 0x32, 0x7e, 0x30, 0x30

NUM5:
    .byte 0x00, 0x7e, 0x06, 0x3e, 0x60, 0x60, 0x66, 0x3c

NUM6:
    .byte 0x00, 0x3c, 0x66, 0x06, 0x3e, 0x66, 0x66, 0x3c

NUM7:
    .byte 0x00, 0x7e, 0x66, 0x30, 0x30, 0x18, 0x18, 0x18

NUM8:
    .byte 0x00, 0x3c, 0x66, 0x66, 0x3c, 0x66, 0x66, 0x3c

NUM9:
    .byte 0x00, 0x3c, 0x66, 0x66, 0x7c, 0x60, 0x66, 0x3c

SEMICOLON: # 10
    .byte 0x00, 0x00, 0x18, 0x18, 0x00, 0x18, 0x18, 0x00

SLASH: # 11
    .byte 0x00, 0x00, 0x60, 0x30, 0x18, 0x0c, 0x06, 0x00

BLANK: # 12
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

UNDERLINE: # 13
    .byte 0x00, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

PAUSE: # 14
    .byte 0x00, 0x00, 0x66, 0x66, 0x66, 0x66, 0x66, 0x00

PLAY: # 15
    .byte 0x00, 0x00, 0x08, 0x18, 0x38, 0x18, 0x08, 0x00

    .equ  ARRAY_31_DAYS_MONTHS_ELEMENT_WIDTH, 1          # 1 byte
ARRAY_31_DAYS_MONTHS:
    .byte 1, 3, 5, 7, 8, 10, 12, '\n'

    .text
# region main
main:
# init address for stack's top
    li    sp, 0x80000000

    call  init_time_test5
    call  init_board
    li    FSM_STATE, FSM_STATE_UP_TIME
    li    a7, PLAY_CODE
    call  display_play_pause

# FIXME: test only section, delete on release

# FIXME: test only section, delete on release

main_loop:
    call  fsm
    call  check_button
    call  check_fsm

    j     main_loop

    addi  a0, x0, 17                                     # exit with code
    addi  a1, x0, 0
    ecall
# endregion main

# region fsm
fsm:
# TODO: COMPLETE THIS
# FSM_STATE_UP_TIME:
    li    t0, FSM_STATE_UP_TIME
    bne   FSM_STATE, t0, fsm_skip_FSM_STATE_UP_TIME      # if FSM_STATE != FSM_STATE_UP_TIME
# else
# state function
    addi  sp, sp, -4
    sw    ra, 0(sp)
    call  up_time # ra = next ins
    lw    ra, 0(sp)
    addi  sp, sp, 4
fsm_skip_FSM_STATE_UP_TIME:

# ALL CHANGE STATE IS TRIGGERED BY BUTTON 1
    beq   BUTTON_1, x0, fsm_skip_CHANGE # if BUTTON_1 == 0 => branch label
# else
# FSM_STATE_CHANGE_SEC:
    li    t0, FSM_STATE_CHANGE_SEC
    bne   FSM_STATE, t0, fsm_skip_FSM_STATE_CHANGE_SEC
# else
    addi  SEC, s2, 1                                     # SEC++
    li    t0, 60
    bne   SEC, t0, skip_reset_sec
    li    SEC, 0

skip_reset_sec:

    addi  sp, sp, -4
    sw    ra, 0(sp)
    call  display_sec
    lw    ra, 0(sp)
    addi  sp, sp, 4
fsm_skip_FSM_STATE_CHANGE_SEC:
# FSM_STATE_CHANGE_MIN:
    li    t0, FSM_STATE_CHANGE_MIN
    bne   FSM_STATE, t0, fsm_skip_FSM_STATE_CHANGE_MIN
# else
    addi  MIN, s3, 1                                     # MIN++
    li    t0, 60
    bne   MIN, t0, skip_reset_min
    li    MIN, 0

skip_reset_min:

    addi  sp, sp, -4
    sw    ra, 0(sp)
    call  display_min
    lw    ra, 0(sp)
    addi  sp, sp, 4
fsm_skip_FSM_STATE_CHANGE_MIN:
# FSM_STATE_CHANGE_HOUR:
    li    t0, FSM_STATE_CHANGE_HOUR
    bne   FSM_STATE, t0, fsm_skip_FSM_STATE_CHANGE_HOUR
# else
    addi  HOUR, s4, 1                                    # HOUR++
    li    t0, 24
    bne   HOUR, t0, skip_reset_hour
    li    HOUR, 0

skip_reset_hour:

    addi  sp, sp, -4
    sw    ra, 0(sp)
    call  display_hour
    lw    ra, 0(sp)
    addi  sp, sp, 4
fsm_skip_FSM_STATE_CHANGE_HOUR:
# FSM_STATE_CHANGE_DAY:
    li    t0, FSM_STATE_CHANGE_DAY
    bne   FSM_STATE, t0, fsm_skip_FSM_STATE_CHANGE_DAY
# else
    addi  DAY, s5, 1                                     # DAY++

    addi  sp, sp, -4
    sw    ra, 0(sp)
    call  get_last_day_of_month
    lw    ra, 0(sp)
    addi  sp, sp, 4

    ble   DAY, a7, skip_reset_day
    li    DAY, 1

skip_reset_day:

    addi  sp, sp, -4
    sw    ra, 0(sp)
    call  display_day
    lw    ra, 0(sp)
    addi  sp, sp, 4
fsm_skip_FSM_STATE_CHANGE_DAY:
# FSM_STATE_CHANGE_MONTH:
    li    t0, FSM_STATE_CHANGE_MONTH
    bne   FSM_STATE, t0, fsm_skip_FSM_STATE_CHANGE_MONTH
# else
    addi  MONTH, s6, 1                                   # MONTH++
    li    t0, 12
    ble   MONTH, t0, skip_reset_month
    li    MONTH, 1
skip_reset_month:

    addi  sp, sp, -4
    sw    ra, 0(sp)
    call  display_month
    lw    ra, 0(sp)
    addi  sp, sp, 4
fsm_skip_FSM_STATE_CHANGE_MONTH:
# FSM_STATE_CHANGE_YEAR:
    li    t0, FSM_STATE_CHANGE_YEAR
    bne   FSM_STATE, t0, fsm_skip_FSM_STATE_CHANGE_YEAR
# else
    addi  YEAR, s7, 1                                    # YEAR++
    li    t0, 9999
    blt   YEAR, t0, skip_reset_year
    li    YEAR, 0

skip_reset_year:

    addi  sp, sp, -4
    sw    ra, 0(sp)
    call  display_year
    lw    ra, 0(sp)
    addi  sp, sp, 4
fsm_skip_FSM_STATE_CHANGE_YEAR:

fsm_skip_CHANGE:

    ret
# TODO: COMPLETE THIS
# endregion fsm

# region display_play_pause
# parameters:
# - a7: = 1 play, = 0 pause
display_play_pause:
    addi  sp, sp, -4
    sw    ra, 0(sp)
    li    a3, 14
    add   a3, a3, a7
    li    a4, PLAY_PAUSE_BLOCK_Y
    li    a5, PLAY_PAUSE_BLOCK_X
    call  display_char
    lw    ra, 0(sp)
    addi  sp, sp, 4
    ret

# region check_button
check_button:
    li    a0, 0x122 # button 1 button 0 (a0)
    ecall
    andi  BUTTON_0, a0, BUTTON_0_MASK
    andi  BUTTON_1, a0, BUTTON_1_MASK
    mv    a1, a0
    li    a0, 0x121
    ecall
    ret
# endregion check_button

# region check_fsm
check_fsm:
    beq   BUTTON_0, x0, check_fsm_done                   # if no press button 0
# else
    li    t0, FSM_STATE_CHANGE_YEAR
    beq   FSM_STATE, t0, fsm_change_to_up_time           # if current state is last state, next state is up time (play)
# else
    li    t0, FSM_STATE_UP_TIME
    bne   FSM_STATE, t0, fsm_pass_pause_up_time          # if current state is not up time, next state is still pause (pause)
# else
    addi  sp, sp, -4
    sw    ra, 0(sp)
    li    a7, PAUSE_CODE
    call  display_play_pause
    lw    ra, 0(sp)
    addi  sp, sp, 4

fsm_pass_pause_up_time:
    addi  FSM_STATE, FSM_STATE, 1                        # Next state

# FSM_STATE_CHANGE_SEC:
    li    t0, FSM_STATE_CHANGE_SEC
    bne   FSM_STATE, t0, skip_FSM_STATE_CHANGE_SEC
    addi  sp, sp, -4
    sw    ra, 0(sp)
    li    a7, 1
    call  display_select_sec                             # enable sec
    lw    ra, 0(sp)
    addi  sp, sp, 4
skip_FSM_STATE_CHANGE_SEC:
# FSM_STATE_CHANGE_MIN:
    li    t0, FSM_STATE_CHANGE_MIN
    bne   FSM_STATE, t0, skip_FSM_STATE_CHANGE_MIN
    addi  sp, sp, -4
    sw    ra, 0(sp)
    li    a7, 0
    call  display_select_sec                             # disable sec
    lw    ra, 0(sp)
    addi  sp, sp, 4
    addi  sp, sp, -4
    sw    ra, 0(sp)
    li    a7, 1
    call  display_select_min                             # enable min
    lw    ra, 0(sp)
    addi  sp, sp, 4
skip_FSM_STATE_CHANGE_MIN:
# FSM_STATE_CHANGE_HOUR:
    li    t0, FSM_STATE_CHANGE_HOUR
    bne   FSM_STATE, t0, skip_FSM_STATE_CHANGE_HOUR
    addi  sp, sp, -4
    sw    ra, 0(sp)
    li    a7, 0
    call  display_select_min                             # disable min
    lw    ra, 0(sp)
    addi  sp, sp, 4
    addi  sp, sp, -4
    sw    ra, 0(sp)
    li    a7, 1
    call  display_select_hour                            # enable hour
    lw    ra, 0(sp)
    addi  sp, sp, 4
skip_FSM_STATE_CHANGE_HOUR:
# FSM_STATE_CHANGE_DAY:
    li    t0, FSM_STATE_CHANGE_DAY
    bne   FSM_STATE, t0, skip_FSM_STATE_CHANGE_DAY
    addi  sp, sp, -4
    sw    ra, 0(sp)
    li    a7, 0
    call  display_select_hour                            # disable hour
    lw    ra, 0(sp)
    addi  sp, sp, 4
    addi  sp, sp, -4
    sw    ra, 0(sp)
    li    a7, 1
    call  display_select_day                             # enable day
    lw    ra, 0(sp)
    addi  sp, sp, 4
skip_FSM_STATE_CHANGE_DAY:
# FSM_STATE_CHANGE_MONTH:
    li    t0, FSM_STATE_CHANGE_MONTH
    bne   FSM_STATE, t0, skip_FSM_STATE_CHANGE_MONTH
    addi  sp, sp, -4
    sw    ra, 0(sp)
    li    a7, 0
    call  display_select_day                             # disable day
    lw    ra, 0(sp)
    addi  sp, sp, 4
    addi  sp, sp, -4
    sw    ra, 0(sp)
    li    a7, 1
    call  display_select_month                           # enable month
    lw    ra, 0(sp)
    addi  sp, sp, 4
skip_FSM_STATE_CHANGE_MONTH:
# FSM_STATE_CHANGE_YEAR:
    li    t0, FSM_STATE_CHANGE_YEAR
    bne   FSM_STATE, t0, skip_FSM_STATE_CHANGE_YEAR
    addi  sp, sp, -4
    sw    ra, 0(sp)
    li    a7, 0
    call  display_select_month                           # disable month
    lw    ra, 0(sp)
    addi  sp, sp, 4
    addi  sp, sp, -4
    sw    ra, 0(sp)
    li    a7, 1
    call  display_select_year                            # enable year
    lw    ra, 0(sp)
    addi  sp, sp, 4
skip_FSM_STATE_CHANGE_YEAR:

    j     check_fsm_done

fsm_change_to_up_time:
    li    FSM_STATE, FSM_STATE_UP_TIME

    addi  sp, sp, -4
    sw    ra, 0(sp)
    li    a7, 0
    call  display_select_year                            # disable year
    lw    ra, 0(sp)
    addi  sp, sp, 4
    addi  sp, sp, -4

    addi  sp, sp, -4
    sw    ra, 0(sp)
    li    a7, PLAY_CODE
    call  display_play_pause
    lw    ra, 0(sp)
    addi  sp, sp, 4

check_fsm_done:

    ret
# endregion check_fsm

# region display_select_sec
display_select_sec:
# a7: = 1 => enable, else if = 0 => disable
    addi  sp, sp, -8
    sw    ra, 0(sp)
    sw    a7, 4(sp)
    li    a3, 12
    add   a3, a3, a7
    li    a4, 7
    li    a5, 2
    call  display_char
    lw    ra, 0(sp)
    lw    a7, 4(sp)
    addi  sp, sp, 8

    addi  sp, sp, -4
    sw    ra, 0(sp)
    li    a3, 12
    add   a3, a3, a7
    li    a4, 8
    li    a5, 2
    call  display_char
    lw    ra, 0(sp)
    addi  sp, sp, 4

    ret

# endregion display_select_sec

# region display_select_min
display_select_min:
# a7: = 1 => disable, else if = 0 => enable
    addi  sp, sp, -8
    sw    ra, 0(sp)
    sw    a7, 4(sp)
    li    a3, 12
    add   a3, a3, a7
    li    a4, 4
    li    a5, 2
    call  display_char
    lw    ra, 0(sp)
    lw    a7, 4(sp)
    addi  sp, sp, 8

    addi  sp, sp, -4
    sw    ra, 0(sp)
    li    a3, 12
    add   a3, a3, a7
    li    a4, 5
    li    a5, 2
    call  display_char
    lw    ra, 0(sp)
    addi  sp, sp, 4

    ret

# endregion display_select_min

# region display_select_hour
display_select_hour:
# a7: = 1 => disable, else if = 0 => enable
    addi  sp, sp, -8
    sw    ra, 0(sp)
    sw    a7, 4(sp)
    li    a3, 12
    add   a3, a3, a7
    li    a4, 1
    li    a5, 2
    call  display_char
    lw    ra, 0(sp)
    lw    a7, 4(sp)
    addi  sp, sp, 8

    addi  sp, sp, -4
    sw    ra, 0(sp)
    li    a3, 12
    add   a3, a3, a7
    li    a4, 2
    li    a5, 2
    call  display_char
    lw    ra, 0(sp)
    addi  sp, sp, 4

    ret

# endregion display_select_hour

# region display_select_day
display_select_day:
# a7: = 1 => disable, else if = 0 => enable
    addi  sp, sp, -8
    sw    ra, 0(sp)
    sw    a7, 4(sp)
    li    a3, 12
    add   a3, a3, a7
    li    a4, 0
    li    a5, 4
    call  display_char
    lw    ra, 0(sp)
    lw    a7, 4(sp)
    addi  sp, sp, 8

    addi  sp, sp, -4
    sw    ra, 0(sp)
    li    a3, 12
    add   a3, a3, a7
    li    a4, 1
    li    a5, 4
    call  display_char
    lw    ra, 0(sp)
    addi  sp, sp, 4

    ret

# endregion display_select_day

# region display_select_month
display_select_month:
# a7: = 1 => disable, else if = 0 => enable
    addi  sp, sp, -8
    sw    ra, 0(sp)
    sw    a7, 4(sp)
    li    a3, 12
    add   a3, a3, a7
    li    a4, 3
    li    a5, 4
    call  display_char
    lw    ra, 0(sp)
    lw    a7, 4(sp)
    addi  sp, sp, 8

    addi  sp, sp, -4
    sw    ra, 0(sp)
    li    a3, 12
    add   a3, a3, a7
    li    a4, 4
    li    a5, 4
    call  display_char
    lw    ra, 0(sp)
    addi  sp, sp, 4

    ret

# endregion display_select_month

# region display_select_year
display_select_year:
# a7: = 1 => disable, else if = 0 => enable
    addi  sp, sp, -8
    sw    ra, 0(sp)
    sw    a7, 4(sp)
    li    a3, 12
    add   a3, a3, a7
    li    a4, 6
    li    a5, 4
    call  display_char
    lw    ra, 0(sp)
    lw    a7, 4(sp)
    addi  sp, sp, 8

    addi  sp, sp, -8
    sw    ra, 0(sp)
    sw    a7, 4(sp)
    li    a3, 12
    add   a3, a3, a7
    li    a4, 7
    li    a5, 4
    call  display_char
    lw    ra, 0(sp)
    lw    a7, 4(sp)
    addi  sp, sp, 8

    addi  sp, sp, -8
    sw    ra, 0(sp)
    sw    a7, 4(sp)
    li    a3, 12
    add   a3, a3, a7
    li    a4, 8
    li    a5, 4
    call  display_char
    lw    ra, 0(sp)
    lw    a7, 4(sp)
    addi  sp, sp, 8

    addi  sp, sp, -4
    sw    ra, 0(sp)
    li    a3, 12
    add   a3, a3, a7
    li    a4, 9
    li    a5, 4
    call  display_char
    lw    ra, 0(sp)
    addi  sp, sp, 4

    ret

# endregion display_select_year

# region init_board
init_board:
# SEMICOLON ': '
# push ra
    addi  sp, sp, -4
    sw    ra, 0(sp)

# call func
# (y, x) = (3, 1)
    li    a3, 10
    li    a4, 3
    li    a5, 1
    call  display_char

# pop ra
    lw    ra, 0(sp)
    addi  sp, sp, 4

# push ra
    addi  sp, sp, -4
    sw    ra, 0(sp)

# call func
# (y, x) = (6, 1)
    li    a3, 10
    li    a4, 6
    li    a5, 1
    call  display_char

# pop ra
    lw    ra, 0(sp)
    addi  sp, sp, 4

# SLASH '/'
# push ra
    addi  sp, sp, -4
    sw    ra, 0(sp)

# call func
# (y, x) = (2, 3)
    li    a3, 11
    li    a4, 2
    li    a5, 3
    call  display_char

# pop ra
    lw    ra, 0(sp)
    addi  sp, sp, 4

# push ra
    addi  sp, sp, -4
    sw    ra, 0(sp)

# call func
# (y, x) = (5, 3)
    li    a3, 11
    li    a4, 5
    li    a5, 3
    call  display_char

# pop ra
    lw    ra, 0(sp)
    addi  sp, sp, 4

    ret

# endregion init_board

# region display_sec
display_sec:
# SEC bin to bcd
# push ra
    addi  sp, sp, -4
    sw    ra, 0(sp)

# call func
    mv    a3, s2                                         # s2 (SEC)
    call  bin2bcd                                        # return a7, a6, a5, a4 as sec3, sec2, sec1, sec0 (bcd format)

# pop ra
    lw    ra, 0(sp)
    addi  sp, sp, 4

# Display sec1
# push ra and sec0 (a4)
    addi  sp, sp, -8
    sw    ra, 0(sp)
    sw    a4, 4(sp)

# call func
    mv    a3, a5
    li    a4, SEC1_BLOCK_Y
    li    a5, TIME_BLOCK_X
    call  display_char

# pop ra and sec0 (a4) to a3
    lw    ra, 0(sp)
    lw    a3, 4(sp)
    addi  sp, sp, 8

# Display sec0
# push ra
    addi  sp, sp, -4
    sw    ra, 0(sp)

# call func
# a3 currently stored sec0
    li    a4, SEC0_BLOCK_Y
    li    a5, TIME_BLOCK_X
    call  display_char

# pop ra
    lw    ra, 0(sp)
    addi  sp, sp, 4

    ret
# endregion display_sec

# region display_min
display_min:
# MIN bin to bcd
# push ra
    addi  sp, sp, -4
    sw    ra, 0(sp)

# call func
    mv    a3, s3                                         # s3 (MIN)
    call  bin2bcd                                        # return a7, a6, a5, a4 as min3, min2, min1, min0 (bcd format)

# pop ra
    lw    ra, 0(sp)
    addi  sp, sp, 4

# Display min1
# push ra and min0 (a4)
    addi  sp, sp, -8
    sw    ra, 0(sp)
    sw    a4, 4(sp)

# call func
    mv    a3, a5
    li    a4, MIN1_BLOCK_Y
    li    a5, TIME_BLOCK_X
    call  display_char

# pop ra and min0 (a4) to a3
    lw    ra, 0(sp)
    lw    a3, 4(sp)
    addi  sp, sp, 8

# Display min0
# push ra
    addi  sp, sp, -4
    sw    ra, 0(sp)

# call func
# a3 currently stored min0
    li    a4, MIN0_BLOCK_Y
    li    a5, TIME_BLOCK_X
    call  display_char

# pop ra
    lw    ra, 0(sp)
    addi  sp, sp, 4

    ret
# endregion display_min

# region display_hour
display_hour:
# HOUR bin to bcd
# push ra
    addi  sp, sp, -4
    sw    ra, 0(sp)

# call func
    mv    a3, s4                                         # s4 (HOUR)
    call  bin2bcd                                        # return a7, a6, a5, a4 as hour3, hour2, hour1, hour0 (bcd format)

# pop ra
    lw    ra, 0(sp)
    addi  sp, sp, 4

# Display hour1
# push ra and hour0 (a4)
    addi  sp, sp, -8
    sw    ra, 0(sp)
    sw    a4, 4(sp)

# call func
    mv    a3, a5
    li    a4, HOUR1_BLOCK_Y
    li    a5, TIME_BLOCK_X
    call  display_char

# pop ra and hour0 (a4) to a3
    lw    ra, 0(sp)
    lw    a3, 4(sp)
    addi  sp, sp, 8

# Display hour0
# push ra
    addi  sp, sp, -4
    sw    ra, 0(sp)

# call func
# a3 currently stored hour0
    li    a4, HOUR0_BLOCK_Y
    li    a5, TIME_BLOCK_X
    call  display_char

# pop ra
    lw    ra, 0(sp)
    addi  sp, sp, 4

    ret
# endregion display_hour

# region display_day
display_day:
# DAY bin to bcd
# push ra
    addi  sp, sp, -4
    sw    ra, 0(sp)

# call func
    mv    a3, s5                                         # s5 (DAY)
    call  bin2bcd                                        # return a7, a6, a5, a4 as day3, day2, day1, day0 (bcd format)

# pop ra
    lw    ra, 0(sp)
    addi  sp, sp, 4

# Display hour1
# push ra and day0 (a4)
    addi  sp, sp, -8
    sw    ra, 0(sp)
    sw    a4, 4(sp)

# call func
    mv    a3, a5
    li    a4, DAY1_BLOCK_Y
    li    a5, DATE_BLOCK_X
    call  display_char

# pop ra and day0 (a4) to a3
    lw    ra, 0(sp)
    lw    a3, 4(sp)
    addi  sp, sp, 8

# Display day0
# push ra
    addi  sp, sp, -4
    sw    ra, 0(sp)

# call func
# a3 currently stored day0
    li    a4, DAY0_BLOCK_Y
    li    a5, DATE_BLOCK_X
    call  display_char

# pop ra
    lw    ra, 0(sp)
    addi  sp, sp, 4

    ret
# endregion display_day

# region display_month
display_month:
# MONTH bin to bcd
# push ra
    addi  sp, sp, -4
    sw    ra, 0(sp)

# call func
    mv    a3, s6                                         # s6 (MONTH)
    call  bin2bcd                                        # return a7, a6, a5, a4 as month3, month2, month1, month0 (bcd format)

# pop ra
    lw    ra, 0(sp)
    addi  sp, sp, 4

# Display hour1
# push ra and month0 (a4)
    addi  sp, sp, -8
    sw    ra, 0(sp)
    sw    a4, 4(sp)

# call func
    mv    a3, a5
    li    a4, MONTH1_BLOCK_Y
    li    a5, DATE_BLOCK_X
    call  display_char

# pop ra and month0 (a4) to a3
    lw    ra, 0(sp)
    lw    a3, 4(sp)
    addi  sp, sp, 8

# Display month0
# push ra
    addi  sp, sp, -4
    sw    ra, 0(sp)

# call func
# a3 currently stored month0
    li    a4, MONTH0_BLOCK_Y
    li    a5, DATE_BLOCK_X
    call  display_char

# pop ra
    lw    ra, 0(sp)
    addi  sp, sp, 4

    ret
# endregion display_month

# region display_year
display_year:
# YEAR bin to bcd
# push ra
    addi  sp, sp, -4
    sw    ra, 0(sp)

# call func
    mv    a3, s7                                         # s7 (YEAR)
    call  bin2bcd                                        # return a7, a6, a5, a4 as year3, year2, year1, year0 (bcd format)

# pop ra
    lw    ra, 0(sp)
    addi  sp, sp, 4

# Display year3
# push ra, a6 a5 a4
    addi  sp, sp, -16
    sw    ra, 0(sp)
    sw    a6, 4(sp)
    sw    a5, 8(sp)
    sw    a4, 12(sp)

# call func
    mv    a3, a7
    li    a4, YEAR3_BLOCK_Y
    li    a5, DATE_BLOCK_X
    call  display_char

# pop ra, a5 a4. pop a6 to a3
    lw    ra, 0(sp)
    lw    a3, 4(sp)
    lw    a5, 8(sp)
    lw    a4, 12(sp)
    addi  sp, sp, 16

# Display year2
# push ra, a5 a4
    addi  sp, sp, -12
    sw    ra, 0(sp)
    sw    a5, 4(sp)
    sw    a4, 8(sp)

# call func
    li    a4, YEAR2_BLOCK_Y
    li    a5, DATE_BLOCK_X
    call  display_char

# pop ra, a4. pop a5 to a3
    lw    ra, 0(sp)
    lw    a3, 4(sp)
    lw    a4, 8(sp)
    addi  sp, sp, 12

# Display year1
# push ra, a4
    addi  sp, sp, -8
    sw    ra, 0(sp)
    sw    a4, 4(sp)

# call func
    li    a4, YEAR1_BLOCK_Y
    li    a5, DATE_BLOCK_X
    call  display_char

# pop ra. pop a4 to a3
    lw    ra, 0(sp)
    lw    a3, 4(sp)
    addi  sp, sp, 8

# Display year0
# push ra
    addi  sp, sp, -4
    sw    ra, 0(sp)

# call func
    li    a4, YEAR0_BLOCK_Y
    li    a5, DATE_BLOCK_X
    call  display_char

# pop ra
    lw    ra, 0(sp)
    addi  sp, sp, 4


    ret
# endregion display_year

# region display_char
display_char:
# parameters:
# a3: DISPLAY_PIXEL_CODE_INDEX
# a4: DISPLAY_PIXEL_POSITION_Y
# a5: DISPLAY_PIXEL_POSITION_X

# Store a3 (DISPLAY_PIXEL_CODE_INDEX) for later func call parameter
    addi  sp, sp, -4                                     # push a3 (DISPLAY_PIXEL_CODE_INDEX)
    sw    a3, 0(sp)

# get starting (y, x)
    mv    a3, a4                                         # Y
    mv    a4, a5                                         # X

# Store return address
    addi  sp, sp, -4                                     # push ra
    sw    ra, 0(sp)

# Call func
    call  get_staring_yx                                 # return a7 as starting (y, x) = (DISPLAY_PIXEL_POSITION_Y * 8, DISPLAY_PIXEL_POSITION_X * 8)

# Restore return address
    lw    ra, 0(sp)                                      # pop ra
    addi  sp, sp, 4

    mv    a1, a7

# get first element address of row array of the char code to store in a3
# Restore a3 (DISPLAY_PIXEL_CODE_INDEX) for func call parameter
    lw    a3, 0(sp)                                      # pop a3 (DISPLAY_PIXEL_CODE_INDEX)
    addi  sp, sp, 4

# Store return address
    addi  sp, sp, -4                                     # push ra
    sw    ra, 0(sp)

# Call func
    call  get_first_element_address                      # return a7 as first element address of row array of the char code

# Restore return address
    lw    ra, 0(sp)                                      # pop ra
    addi  sp, sp, 4

    mv    a3, a7

# display char block
# Store return address
    addi  sp, sp, -4                                     # push ra
    sw    ra, 0(sp)

# Call func
    call  display_char_block

# Restore return address
    lw    ra, 0(sp)                                      # pop ra
    addi  sp, sp, 4
    ret

# endregion display_char

# region display_char_block
display_char_block:
# parameters:
# - a3: first element address of row array of the char code
# - a1: (DISPLAY_PIXEL_YX): starting (y, x) of the display block
# return:
# - void

# t0, t1, t3: temp vars short life circle
# t3: bit mask to get row's pixel
# t4, t5: max x, max y
# t6: starting y

# Borrowing some register
# s0: current pointer to row element in row array
# s1: current bit mask to get pixel in row element
# s2: current value of row element in row array

# store all saved register that we want to use (s0 - s5)
    addi  sp, sp, -24
    sw    s0, 0(sp)
    sw    s1, 4(sp)
    sw    s2, 8(sp)
    sw    s3, 12(sp)
    sw    s4, 16(sp)
    sw    s5, 20(sp)

    li    ECALL_CODE, DISPLAY_PIXEL                      # load DISPLAY_PIXEL to ECALL_CODE

    mv    s0, a3                                         # pointer to row array of the char code

    li    t0, 0x0000ffff                                 # mask to get x
    and   t0, DISPLAY_PIXEL_YX, t0                       # get starting_pixel_x by masking staring DISPLAY_PIXEL_YX with mask to get x
    addi  t4, t0, 0x00000007                             # max x

    li    t0, 0xffff0000                                 # mask to get y
    and   t6, DISPLAY_PIXEL_YX, t0                       # get starting_pixel_y by masking staring DISPLAY_PIXEL_YX with mask to get y
    li    t0, 0x00070000                                 # value to get max y
    add   t5, t6, t0                                     # max y

display_char_row_loop:
    li    s1, 0x01                                       # 00000001 bit mask to get first pixel of row
    lbu   s2, 0(s0)                                      # get value of row element

display_char_pixel_loop:


# display
    and   t0, s2, s1                                     # get current pixel of row
    bne   t0, x0, display_on                             # if != 0 => on
# else

# display_off:
    li    DISPLAY_PIXEL_COLOR, 0x00000000                # COLOR OFF
    j     display_call

display_on:
    li    DISPLAY_PIXEL_COLOR, 0x0000ff00                # COLOR ON

display_call:
    ecall

# display_done:
    li    t0, 0xffff0000                                 # mask to get y
    and   t0, DISPLAY_PIXEL_YX, t0                       # get y by using mask
    beq   t0, t5, display_char_pixel_loop_done           # if y == max y
# else
    li    t0, 0x00010000                                 # value to y++
    add   DISPLAY_PIXEL_YX, DISPLAY_PIXEL_YX, t0         # y++
    slli  s1, s1, 1                                      # bit mask left shift logical <<
    j     display_char_pixel_loop                        # loop back

display_char_pixel_loop_done:
    li    t0, 0x0000ffff                                 # mask to get x
    and   t0, DISPLAY_PIXEL_YX, t0                       # get x by using mask
    beq   t0, t4, display_char_row_loop_done             # if x == max x
# else
    addi  t0, t0, 0x00000001                             # x++
    addi  s0, s0, 1                                      # point to the next element in row array
    add   DISPLAY_PIXEL_YX, t0, t6                       # (y, x) = (starting y, x)
    j     display_char_row_loop

display_char_row_loop_done:
# restore all saved register that we push to stack (s0 - s5)
    lw    s0, 0(sp)
    lw    s1, 4(sp)
    lw    s2, 8(sp)
    lw    s3, 12(sp)
    lw    s4, 16(sp)
    lw    s5, 20(sp)
    addi  sp, sp, 24

    ret

# endregion display_char_block

# region get_staring_yx
get_staring_yx:
# Get starting (y, x) of the display block
# starting (y, x) = (DISPLAY_PIXEL_POSITION_Y * 8, DISPLAY_PIXEL_POSITION_X * 8)
# parameters:
# - a3: Y offset index
# - a4: X offset index
# return:
# - a7: starting (y, x)

# example useage:
# li a3, 1 # Y
# li a4, 2 # X
# call get_staring_yx # return a7 as starting (y, x) = (DISPLAY_PIXEL_POSITION_Y * 8, DISPLAY_PIXEL_POSITION_X * 8)

    li    a7, 0x00000000                                 # reset (y, x) = (0, 0)

# offset_y:
    mv    t1, a3                                         # Y offset left to make
    li    t0, 0x00080000                                 # value to y offset ++
offset_y_loop:
    beq   t1, x0, offset_y_loop_done
    add   a7, a7, t0                                     # y offset ++
    addi  t1, t1, -1
    j     offset_y_loop

offset_y_loop_done:

# offset_x:
    mv    t1, a4                                         # X offset left to make
offset_x_loop:
    beq   t1, x0, offset_x_loop_done
    addi  a7, a7, 0x00000008
    addi  t1, t1, -1
    j     offset_x_loop

offset_x_loop_done:
    ret

# endregion get_staring_yx

# region get_first_element_address
get_first_element_address:
# Get first element address of row array of the char code coresponding to char code index want to display
# parameters:
# - a3: char code index want to display (0 --> NUM0, 1 --> NUM1,...)
# return:
# - a7: first element address of row array of the char code

# example useage:
# li a3, 2
# call get_first_element_address # return a7 as first element address of row array of the char code

    la    a7, ARRAY_CHAR_CODES                           # load address ARRAY_CHAR_CODES, point to first char code index

# address_offset:
    mv    t1, a3                                         # offset left to point to char code index
address_offset_loop:
    beq   t1, x0, address_offset_loop_done               # if no offset left to do
# else
    addi  a7, a7, 8
    addi  t1, t1, -1
    j     address_offset_loop                            # loop back

address_offset_loop_done:
    ret

# endregion get_first_element_address

# region up_time
up_time:
    li    t0, 60                                         # temp register to hold value for comparison

# up_time_sec:
    addi  SEC, SEC, 1
    blt   SEC, t0, up_time_done

# up_time_min:
    li    SEC, 0
    addi  MIN, MIN, 1
    blt   MIN, t0, up_time_done

    li    t0, 24                                         # temp register to hold value for comparison

# up_time_hour:
    li    MIN, 0
    addi  HOUR, HOUR, 1
    blt   HOUR, t0, up_time_done

# up_time_day:
    li    HOUR, 0
    addi  DAY, DAY, 1

# push current return address (ra)
    addi  sp, sp, -4                                     # Add 32 bit volume space in stack
    sw    ra, 0(sp)                                      # Store doubleword (32 bit)

# call function get_last_day_of_month. a7 = get_last_day_of_month()
    call  get_last_day_of_month

# pop stored return address (ra)
    lw    ra, 0(sp)                                      # Load doubleword (32 bit)
    addi  sp, sp, 4                                      # Remove 32 bit volume space in stack

    blt   DAY, a7, up_time_done

    li    t0, 12                                         # temp register to hold value for comparison

# update_time_month:
    li    DAY, 1
    addi  MONTH, MONTH, 1
    ble   MONTH, t0, up_time_done

# update_time_year
    li    MONTH, 1
    addi  YEAR, YEAR, 1
    li    t0, 9999
    blt   YEAR, t0, up_time_done
    li    YEAR, 0

up_time_done:
# display sec
    addi  sp, sp, -4
    sw    ra, 0(sp)
    call  display_sec
    lw    ra, 0(sp)
    addi  sp, sp, 4

# display min
    addi  sp, sp, -4
    sw    ra, 0(sp)
    call  display_min
    lw    ra, 0(sp)
    addi  sp, sp, 4

# display hour
    addi  sp, sp, -4
    sw    ra, 0(sp)
    call  display_hour
    lw    ra, 0(sp)
    addi  sp, sp, 4

# display day
    addi  sp, sp, -4
    sw    ra, 0(sp)
    call  display_day
    lw    ra, 0(sp)
    addi  sp, sp, 4

# display month
    addi  sp, sp, -4
    sw    ra, 0(sp)
    call  display_month
    lw    ra, 0(sp)
    addi  sp, sp, 4

# display year
    addi  sp, sp, -4
    sw    ra, 0(sp)
    call  display_year
    lw    ra, 0(sp)
    addi  sp, sp, 4

    ret


# endregion up_time

# region get_last_day_of_month
get_last_day_of_month:
# Return a7 = last day of month
# First check if MONTH == 2, then check YEAR % 4 (2 lsb == 00) => leap year

# check_month_2:
    li    t0, 2
    bne   MONTH, t0, month_not_2                         # if MONTH != 2
# check_month_2_true:
    li    a7, 28                                         # assum last day of month a7 = 28
# check_leap_year:
    andi  t0, YEAR, 0x3                                  # Check 2 lsb
    bnez  t0, get_last_day_of_month_done                 # 2 lsb != 00 => not a leap year, keep a7 = 28 value and return
# check_leap_year_true:
    li    a7, 29                                         # else => leap year, update a7 = 29
    j     get_last_day_of_month_done                     # then return

month_not_2:
# check month 1, 3, 5, 7, 8, 10, 12 => last day of month a7 = 31
# check_month_31_days:
    li    a7, 30                                         # assum not 31 days month
    li    t0, ARRAY_31_DAYS_MONTHS_ELEMENT_WIDTH         # element size = 1 (byte)
    la    t1, ARRAY_31_DAYS_MONTHS                       # byte *t1 = ARRAY_31_DAYS_MONTHS;
    li    t3, '\n'                                       # end of the array
check_month_31_days_loop:
    lb    t2, 0(t1)                                      # t2 = array[t1]
    beq   t2, t3, get_last_day_of_month_done             # Check all elements, not match => 30 days month
    beq   MONTH, t2, check_month_31_days_true
# check_month_31_days_loop_false:
    add   t1, t1, t0                                     # Point to next element. *t1 = *(t1 + t0)
    j     check_month_31_days_loop

check_month_31_days_true:
    li    a7, 31                                         # MONTH == (1 of the element in 31 days month array)
# check_month_31_days_done:

get_last_day_of_month_done:
    ret
# endregion get_last_day_of_month

# region bin2bcd
bin2bcd:
# info: double dabble algorithm is used to convert binary (bin) numbers into binary-coded decimal (bcd) notation
# parameters:
# - a3: bin value to convert to bcd
# return:
# - a7, a6, a5, a4: converted bcd value

# 0xf0000000 # mask to get hex3 xxxx ---- ---- ---- <bin value>
# 0x0f000000 # mask to get hex2 ---- xxxx ---- ---- <bin value>
# 0x00f00000 # mask to get hex1 ---- ---- xxxx ---- <bin value>
# 0x000f0000 # mask to get hex0 ---- ---- ---- xxxx <bin value>

    mv    a7, a3                                         # hold bin value to convert to bcd <target bcd> <bin value>
    li    t0, 0xffff                                     # mask to get low part
# remove all high part to make sure

    li    t1, 15                                         # number of left shift and check hex operation left to do (except last shift no need to check hex, just shift)

bin2bcd_loop:
# shift_left:
    beq   t1, x0, bin2bcd_loop_done                      # if left shift to do == 0
# else
    slli  a7, a7, 1                                      # shift 1 bit to the left

# check_hex_and_add:
check_hex:
    li    t3, 0x000f0000                                 # bit mask to get hex0
    li    t4, 0x00050000                                 # value to compare (less than 5 => don't add 3)
    li    t5, 0x00030000                                 # value to add 3 (greater or equal than 5 => add 3)
    li    t6, 4                                          # number of hex left to check

check_hex_loop:
    beq   t6, x0, check_hex_loop_done                    # if no hex left to do
# else
# get_hex:
    and   t0, a7, t3                                     # get hex by using mask
    bltu  t0, t4, hex_no_add_3                           # if hex < 5 => don't add 3
# else
# hex_add_3:
    add   a7, a7, t5                                     # add 3 to hex

hex_no_add_3:

# next_hex:
    slli  t3, t3, HEX_BITS
    slli  t4, t4, HEX_BITS
    slli  t5, t5, HEX_BITS

    addi  t6, t6, -1
    j     check_hex_loop

check_hex_loop_done:
    addi  t1, t1, -1
    j     bin2bcd_loop

bin2bcd_loop_done:
    slli  a7, a7, 1                                      # last shift without check hex

    li    t0, 0x000f                                     # mask to get last hex _ _ _ x
    srli  a7, a7, 16                                     # shift back to low part _ _ _ _ a b c d
    and   a4, a7, t0                                     # store hex0 (d) to a3
    srli  a7, a7, HEX_BITS                               # shift 1 hex to right
    and   a5, a7, t0                                     # store hex1 (c) to a4
    srli  a7, a7, HEX_BITS                               # shift 1 hex to right
    and   a6, a7, t0                                     # store hex2 (b) to a5
    srli  a7, a7, HEX_BITS                               # shift 1 hex to right
    and   a7, a7, t0                                     # store hex3 (a) to a6
    ret
# endregion bin2bcd

# region test cases
init_time_test0:
# 18/07/2009 15-24-36
    li    SEC, 56
    li    MIN, 24
    li    HOUR, 15
    li    DAY, 18
    li    MONTH, 7
    li    YEAR, 2001
    ret

init_time_test1:
# 29/2/2024 23-59-59
    li    SEC, 56
    li    MIN, 59
    li    HOUR, 23
    li    DAY, 29
    li    MONTH, 2
    li    YEAR, 2024
    ret

init_time_test2:
# 31 days month
# 31/3/2024 23-59-59
    li    SEC, 56
    li    MIN, 59
    li    HOUR, 23
    li    DAY, 31
    li    MONTH, 3
    li    YEAR, 2024
    ret

init_time_test3:
# 30 days month
# 30/4/2024 23-59-56
    li    SEC, 56
    li    MIN, 59
    li    HOUR, 23
    li    DAY, 30
    li    MONTH, 4
    li    YEAR, 2024
    ret

init_time_test4:
# end of year
# 31/12/2024 23-59-56
    li    SEC, 56
    li    MIN, 59
    li    HOUR, 23
    li    DAY, 31
    li    MONTH, 12
    li    YEAR, 2024
    ret

init_time_test5:
# end of year
# 31/12/9999 23-59-56
    li    SEC, 56
    li    MIN, 59
    li    HOUR, 23
    li    DAY, 31
    li    MONTH, 12
    li    YEAR, 9999
    ret
# region test cases