.syntax unified
.cpu cortex-m4
.thumb
.global main

.data
.balign 4
data:
    .word 0

.text
.type main, %function
.thumb_func
main:
    ldr r0, =data
    mov r1, #0x12
    strb r1, [r0]
    mov r1, #0x34
    strb r1, [r0, #1]
    ldr r1, =0xABCD
    strh r1, [r0, #2]
    ldr r2, [r0]       @ R2 = 0xABCD3412
    ldr r1, =0x12345678
    str r1, [r0]       @ Replace all four bytes

stop:
    nop
    b stop
.size main, .-main
