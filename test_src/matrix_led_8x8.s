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
    .equ  BLACK, 0x00
    .equ  BLUE, 0xff

    .data
ARRAY_CHAR_CODES:
NUM0:
# 7e 18 18 18 1c 18 18 00
    .byte 0x00, 0x18, 0x18, 0x1c, 0x18, 0x18, 0x18, 0x7e

NUM1:
# 7e 06 0c 30 60 66 3c 00
    .byte 0x00, 0x3c, 0x66, 0x60, 0x30, 0x0c, 0x06, 0x7e

NUM2:
# 3c 66 60 38 60 66 3c 00
    .byte 0x00, 0x3c, 0x66, 0x60, 0x38, 0x60, 0x66, 0x3c

    .text
main:
    addi  DISPLAY_PIXEL_CODE_INDEX, x0, 0
    addi  DISPLAY_PIXEL_POSITION_X, x0, 1
    addi  DISPLAY_PIXEL_POSITION_Y, x0, 2
    call  display_char

    addi  a0, x0, 17                                     # exit with code
    addi  a1, x0, 0
    ecall

# region display_char
display_char:
# store all saved register that we want to use (s0, s1)
    addi  sp, sp, 24
    sw    s0, 0(sp)
    sw    s1, 4(sp)
    sw    s2, 8(sp)
    sw    s3, 12(sp)
    sw    s4, 16(sp)
    sw    s5, 20(sp)

# compute_pointer:
    la    s2, ARRAY_CHAR_CODES                           # Pointer to ARRAY_CHAR_CODES[DISPLAY_PIXEL_CODE_INDEX][0]
    mv    t1, a3                                         # DISPLAY_PIXEL_CODE_INDEX

compute_pointer_loop:
    beq   t1, x0, compute_pointer_loop_done
    addi  s2, s2, 8
    addi  t1, t1, -1
    j     compute_pointer_loop

compute_pointer_loop_done:

# compute_starting_pixel_yx:
# starting DISPLAY_PIXEL_YX = (y, x) = (DISPLAY_PIXEL_POSITION_Y * 8, DISPLAY_PIXEL_POSITION_X * 8)
    addi  DISPLAY_PIXEL_YX, x0, 0x00000000               # reset (y, x) = (0, 0)

# offset_x:
    mv    t1, a4                                         # DISPLAY_PIXEL_POSITION_Y
# 0x00000008 = value for offset_x++

offset_x_loop:
    beq   t1, x0, offset_x_loop_done
    addi  DISPLAY_PIXEL_YX, DISPLAY_PIXEL_YX, 0x00000008
    addi  t1, t1, -1
    j     offset_x_loop

offset_x_loop_done:

# offset_y:
    mv    t1, a5                                         # DISPLAY_PIXEL_POSITION_X
    li    t2, 0x00080000                                 # value for offset_y++

offset_y_loop:
    beq   t1, x0, offset_y_loop_done
    add   DISPLAY_PIXEL_YX, DISPLAY_PIXEL_YX, t2
    addi  t1, t1, -1
    j     offset_y_loop

offset_y_loop_done:

# display_char:
    li    ECALL_CODE, DISPLAY_PIXEL                      # load DISPLAY_PIXEL to ECALL_CODE

    li    t2, 0x0000ffff                                 # mask to get x
    li    t3, 0xffff0000                                 # mask to get y

    and   t5, DISPLAY_PIXEL_YX, t2                       # get starting_pixel_x by masking staring DISPLAY_PIXEL_YX with mask to get x
    and   t6, DISPLAY_PIXEL_YX, t3                       # get starting_pixel_y by masking staring DISPLAY_PIXEL_YX with mask to get y

    addi  s0, t5, 0x00000007                             # max x
    li    t4, 0x00070000                                 # value to get max y
    add   s1, t6, t4                                     # max y

    li    t4, 0x00010000                                 # value to y++
# 0x00000001 = value to x++

display_char_compute_x:
    li    s3, 0x01                                       # 0000 0001 << mask to get char row bit at col
    lb    s4, 0(s2)                                      # char row element

display_char_compute_y:
    and   t0, s4, s3                                     # Get col bit
    bne   t0, x0, display_on

display_off:
    li    DISPLAY_PIXEL_COLOR, 0x00ff0000
    j     display_pixel

display_on:
    li    DISPLAY_PIXEL_COLOR, BLUE

display_pixel:
    ecall

# display_char_display_done:
    and   t0, DISPLAY_PIXEL_YX, t3                       # get y by using mask
    beq   t0, s1, display_char_compute_y_done            # if y == max y
    add   DISPLAY_PIXEL_YX, DISPLAY_PIXEL_YX, t4         # y++
    slli  s3, s3, 1                                      # col mask <<
    j     display_char_compute_y

display_char_compute_y_done:
    and   t0, DISPLAY_PIXEL_YX, t2                       # get x by using mask
    beq   t0, s0, display_char_compute_x_done            # if x == max x

    addi  DISPLAY_PIXEL_YX, DISPLAY_PIXEL_YX, 0x00000001 # x++
    addi  s2, s2, 1                                      # Point to the next byte element
    and   DISPLAY_PIXEL_YX, DISPLAY_PIXEL_YX, t2         # reset y
    add   DISPLAY_PIXEL_YX, DISPLAY_PIXEL_YX, t6         # y = starting_pixel_y
    j     display_char_compute_x

display_char_compute_x_done:

display_char_done:


# restore all saved register that we push to stack (s0, s1)
    lw    s0, 0(sp)
    lw    s1, 4(sp)
    lw    s2, 8(sp)
    lw    s3, 12(sp)
    lw    s4, 16(sp)
    lw    s5, 20(sp)
    addi  sp, sp, -24

    ret

# endregion display_char


# li a0, 0x101
# li a1, 0x00FF0000
# ecall


# li a0, 0x100
# li a1, 0x00020004
# li a2, 0x00FF0000
# ecall