.syntax unified
.cpu cortex-m4
.thumb
.global main

.data
.balign 4
value:
    .word 0

.text
.type main, %function
.thumb_func
main:
    ldr r0, =value
    mov r1, #42
    str r1, [r0]

stop:
    nop
    b stop
.size main, .-main
