.syntax unified
.cpu cortex-m4
.thumb
.global main

.data
.balign 4
A:
    .space 4
B:
    .space 4
C:
    .space 4

.text
.type main, %function
.thumb_func
main:
    ldr r0, =A
    mov r1, #42
    str r1, [r0]
    ldr r0, =B
    mov r1, #15
    str r1, [r0]
    ldr r0, =A
    ldr r1, [r0]
    ldr r0, =B
    ldr r2, [r0]
    add r3, r1, r2
    ldr r0, =C
    str r3, [r0]       @ C = 57

stop:
    nop
    b stop
.size main, .-main
