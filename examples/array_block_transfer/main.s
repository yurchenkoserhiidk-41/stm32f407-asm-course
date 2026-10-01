.syntax unified
.cpu cortex-m4
.thumb
.global main

.data
.balign 4
numbers:
    .word 10, 20, 30, 40, 50
copy:
    .space 16

.text
.type main, %function
.thumb_func
main:
    ldr r0, =numbers
    ldm r0, {r1-r3}    @ R1 = 10, R2 = 20, R3 = 30; no write-back
    ldm r0, {r1-r4}    @ R4 = 40; R0 still equals base
    ldr r0, =copy
    stm r0, {r1-r4}    @ Copy four words; R0 stays unchanged

stop:
    nop
    b stop
.size main, .-main
