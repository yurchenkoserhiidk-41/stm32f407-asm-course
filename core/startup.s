        .syntax unified
        .cpu cortex-m4
        .thumb

        .section .vectors, "a"
        .word __StackTop
        .word Reset_Handler
        .word Default_Handler
        .word Default_Handler
        .word Default_Handler
        .word Default_Handler
        .word Default_Handler
        .space 16
        .word Default_Handler
        .word Default_Handler
        .space 4
        .word Default_Handler
        .word Default_Handler


        .text

        .global Reset_Handler
        .type Reset_Handler, %function
        .thumb_func
Reset_Handler:
        @ Restore initialized RAM data from its Flash image.
        ldr     r0, =_sidata
        ldr     r1, =__data_start__
        ldr     r2, =__data_end__
copy_data:
        cmp     r1, r2
        bhs     clear_bss_setup
        ldr     r3, [r0], #4
        str     r3, [r1], #4
        b       copy_data

clear_bss_setup:
        ldr     r1, =__bss_start__
        ldr     r2, =__bss_end__
        movs    r3, #0
clear_bss:
        cmp     r1, r2
        bhs     start_main
        str     r3, [r1], #4
        b       clear_bss

start_main:
        bl      main

1:
        b       1b

        .size Reset_Handler, .-Reset_Handler


        .global Default_Handler
        .type Default_Handler, %function
        .thumb_func
Default_Handler:
        b       Default_Handler

.size Default_Handler, .-Default_Handler
