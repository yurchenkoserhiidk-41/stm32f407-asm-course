.syntax unified
.cpu cortex-m4
.thumb
.global main

.data
.balign 4
values:
    .word 10, 20, 30, 40

.text
.type main, %function
.thumb_func
main:
    ldr r0, =values
    ldr r1, [r0, #4]   @ R1 = 20; R0 stays at base
    ldr r2, [r0], #4   @ R2 = 10; R0 becomes base + 4
    ldr r3, [r0, #4]!  @ R3 = 30; R0 becomes base + 8

stop:
    nop
    b stop
.size main, .-main
