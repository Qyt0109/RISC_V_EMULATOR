    .equ  HEX_BITS, 4

    .data


    .text

main:
# init address for stack's top
    li    sp, 0x80000000

    li    a3, 38
bin2bcd_test_loop:
    call  bin2bcd
    nop
    addi  a3, a3, 1
    j     bin2bcd_test_loop

    addi  a0, x0, 17                  # exit with code
    addi  a1, x0, 0
    ecall

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

    mv    a7, a3                      # hold bin value to convert to bcd <target bcd> <bin value>
    li    t0, 0xffff                  # mask to get low part
# remove all high part to make sure

    li    t1, 15                      # number of left shift and check hex operation left to do (except last shift no need to check hex, just shift)

bin2bcd_loop:
# shift_left:
    beq   t1, x0, bin2bcd_loop_done   # if left shift to do == 0
# else
    slli  a7, a7, 1                   # shift 1 bit to the left

# check_hex_and_add:
check_hex:
    li    t3, 0x000f0000              # bit mask to get hex0
    li    t4, 0x00050000              # value to compare (less than 5 => don't add 3)
    li    t5, 0x00030000              # value to add 3 (greater or equal than 5 => add 3)
    li    t6, 4                       # number of hex left to check

check_hex_loop:
    beq   t6, x0, check_hex_loop_done # if no hex left to do
# else
# get_hex:
    and   t0, a7, t3                  # get hex by using mask
    bltu  t0, t4, hex_no_add_3        # if hex < 5 => don't add 3
# else
# hex_add_3:
    add   a7, a7, t5                  # add 3 to hex

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
    slli  a7, a7, 1                   # last shift without check hex

    li    t0, 0x000f                  # mask to get last hex _ _ _ x
    srli  a7, a7, 16                  # shift back to low part _ _ _ _ a b c d
    and   a4, a7, t0                  # store hex0 (d) to a3
    srli  a7, a7, HEX_BITS            # shift 1 hex to right
    and   a5, a7, t0                  # store hex1 (c) to a4
    srli  a7, a7, HEX_BITS            # shift 1 hex to right
    and   a6, a7, t0                  # store hex2 (b) to a5
    srli  a7, a7, HEX_BITS            # shift 1 hex to right
    and   a7, a7, t0                  # store hex3 (a) to a6
    ret
# endregion bin2bcd