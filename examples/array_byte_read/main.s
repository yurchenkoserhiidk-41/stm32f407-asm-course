.syntax unified
.cpu cortex-m4
.thumb
.global main

.data
.balign 4
bytes:
    .byte 10, 20, 30, 40, 50

.text
.type main, %function
.thumb_func
main:
    ldr r0, =bytes
    ldrb r1, [r0, #2]  @ bytes[2] = 30

stop:
    nop
    b stop
.size main, .-main
