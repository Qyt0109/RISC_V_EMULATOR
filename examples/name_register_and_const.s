#define REGISTER_S0, s0

    .equ VALUE_1, 0x10
    .equ VALUE_2, 0x7ff       # 12 bit 0x000 - 0x7ff

main:
    li   s0, VALUE_1
    li   REGISTER_S0, VALUE_2

    nop