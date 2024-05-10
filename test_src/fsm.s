#define BUTTON_0, s10
#define BUTTON_1, s11

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

    .text
main:
    li    FSM_STATE, 0x00
main_loop:
    call  check_button
    call  check_fsm
    j     main_loop

# region check_button
check_button:
    li    a0, 0x122
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
    beq   BUTTON_0, x0, check_fsm_done         # if no press button 0
# else
    li    t0, FSM_STATE_CHANGE_YEAR
    beq   FSM_STATE, t0, fsm_change_to_up_time # if current state is last state
# else
    addi  FSM_STATE, FSM_STATE, 1
    j     check_fsm_done

fsm_change_to_up_time:
    li    FSM_STATE, FSM_STATE_UP_TIME

check_fsm_done:

    ret
# endregion check_fsm