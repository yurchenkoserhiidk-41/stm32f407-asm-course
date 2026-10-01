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
    mov r1, #42
    str r1, [r0, #12]  @ numbers[3] = 42

stop:
    nop
    b stop
.size main, .-main
