        .syntax unified
        .cpu cortex-m4
        .thumb
        .global main

        .text
        .type main, %function

main:
        mov     r0, #100         @ R0 = 100 = 64_16 = 0x64
        mov     r1, #37         @ R1 = 37 = 25_16 = 0x25

        add     r2, r0, r1     @ R2 = 100 + 37 = 0x64 + 0x25
        sub     r3, r0, r1     @ R3 = 0x64 - 0x25

stop:
        nop
        b       stop
