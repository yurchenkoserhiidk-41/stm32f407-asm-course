.syntax unified
.cpu cortex-m4
.thumb
.global main

.data
.balign 4
numbers:
    .word 10, 20, 30, 40, 50

.text
.type main, %function
.thumb_func
main:
    ldr r0, =numbers
    ldr r1, [r0], #4   @ R1 = 10; R0 = base + 4
    ldr r2, [r0], #4   @ R2 = 20; R0 = base + 8
    ldr r3, [r0], #4   @ R3 = 30; R0 = base + 12

stop:
    nop
    b stop
.size main, .-main
