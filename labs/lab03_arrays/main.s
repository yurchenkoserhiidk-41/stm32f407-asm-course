.syntax unified
.cpu cortex-m4
.thumb
.global main

.data
.balign 4
@ TODO: Replace these example values with your variant values.
numbers:
    .word 10, 20, 30, 40, 50
bytes:
    .byte 10, 20, 30, 40, 50

.text
.type main, %function
.thumb_func
main:
    @ TODO: Load elements 0, 2, 4 of each array into R1-R6.
    @ TODO: Replace element 3 of each array.
    nop

stop:
    nop
    b stop
.size main, .-main
