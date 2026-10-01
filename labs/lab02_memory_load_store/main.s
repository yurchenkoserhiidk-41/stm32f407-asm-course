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
    @ TODO: Store your variant inputs in A and B.
    @ TODO: Read A and B, add them, and store the result in C.
    nop

stop:
    nop
    b stop
.size main, .-main
