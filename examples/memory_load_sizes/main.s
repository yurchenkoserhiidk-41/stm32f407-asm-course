.syntax unified
.cpu cortex-m4
.thumb
.global main

.data
.balign 4
data:
    .word 0x12345678

.text
.type main, %function
.thumb_func
main:
    ldr r0, =data
    ldr r1, [r0]       @ R1 = 0x12345678
    ldrb r2, [r0]      @ R2 = 0x78
    ldrh r3, [r0]      @ R3 = 0x5678

stop:
    nop
    b stop
.size main, .-main
