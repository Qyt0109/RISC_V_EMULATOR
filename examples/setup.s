# region define & const

#define REGISTER_A, s0
#define REGISTER_B, s1
#define REGISTER_F, s2

# .equ range from 0x000 - 0x7ff (imm 13 bit)
    .equ    VALUE_A, 0x01
    .equ    VALUE_B, 0x02

# endregion define & const

# region DATA from address 0x10000000
    .data

VAR_S:
    .word   0x00

BYTE_ARRAY:
    .word   0xf0, 0xf1, 0xf2, 0xf3

STRING_ARRAY:
    .string "HELLO WORLD\n"

# endregion DATA

# region TEXT from address 0x00000000

    .text
main:
    li      REGISTER_A, VALUE_A    # REGISTER_A = VALUE_A;
    li      REGISTER_B, VALUE_B    # REGISTER_B = VALUE_B;
    add     REGISTER_F, s0, s1     # REGISTER_F = REGISTER_A + REGISTER_B

    nop

# endregion TEXT