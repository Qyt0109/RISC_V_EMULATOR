#define ECALL_CODE, a0

#define DISPLAY_ALL_PIXELS_COLOR, a1

# Display pixel func's agrs
#define DISPLAY_PIXEL_CODE_INDEX, a3
#define DISPLAY_PIXEL_POSITION_X, a5
#define DISPLAY_PIXEL_POSITION_Y, a4

# Display pixel func's local vars
#define DISPLAY_PIXEL_YX, a1
#define DISPLAY_PIXEL_COLOR, a2

    .equ  DISPLAY_ALL_PIXELS, 0x101
    .equ  DISPLAY_PIXEL, 0x100

    .data
ARRAY_CHAR_CODES:
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
    .text

main:
# init address for stack's top
    li    sp, 0x80000000

    la    a3, NUM1
    li    DISPLAY_PIXEL_YX, 0x00080008
    call display_char_block

    la    a3, NUM2
    li    DISPLAY_PIXEL_YX, 0x00100008
    call display_char_block

    la    a3, NUM3
    li    DISPLAY_PIXEL_YX, 0x00200008
    call display_char_block

    la    a3, NUM0
    li    DISPLAY_PIXEL_YX, 0x00280008
    call display_char_block

    la    a3, NUM2
    li    DISPLAY_PIXEL_YX, 0x00380008
    call display_char_block

    la    a3, NUM1
    li    DISPLAY_PIXEL_YX, 0x00400008
    call display_char_block


    la    a3, NUM0
    li    DISPLAY_PIXEL_YX, 0x00000018
    call display_char_block

    la    a3, NUM1
    li    DISPLAY_PIXEL_YX, 0x00080018
    call display_char_block

    la    a3, NUM1
    li    DISPLAY_PIXEL_YX, 0x00180018
    call display_char_block

    la    a3, NUM2
    li    DISPLAY_PIXEL_YX, 0x00200018
    call display_char_block

    la    a3, NUM2
    li    DISPLAY_PIXEL_YX, 0x00300018
    call display_char_block

    la    a3, NUM0
    li    DISPLAY_PIXEL_YX, 0x00380018
    call display_char_block

    la    a3, NUM2
    li    DISPLAY_PIXEL_YX, 0x00400018
    call display_char_block

    la    a3, NUM0
    li    DISPLAY_PIXEL_YX, 0x00480018
    call display_char_block
    

    addi  a0, x0, 17                                     # exit with code
    addi  a1, x0, 0
    ecall

# region display_char_block
display_char_block:
# parameter:
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
    li    DISPLAY_PIXEL_COLOR, 0x00ff0000
    j     display_call

display_on:
    li    DISPLAY_PIXEL_COLOR, 0x0000ff00

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