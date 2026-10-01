# Practical Work 2 — Memory, Load/Store and Data Sizes

Work in `labs/lab02_memory_load_store/` on branch `lab02` in your personal fork.
Follow the [student workflow](../../docs/student-workflow.md).
Build from the repository root: `make PROJECT=labs/lab02_memory_load_store`.

## Goal

Understand RAM addresses, `.data`, `.space`, byte-addressable memory, little
endian byte order, `LDR/STR`, `LDRB/STRB`, `LDRH/STRH`, effective addresses,
and offset, pre-indexed, and post-indexed addressing.

## Before you begin

One address identifies one byte. A byte is 8 bits, a halfword is 16 bits, and a
word is 32 bits. Align halfwords to 2-byte boundaries and words to 4-byte
boundaries; `.balign 4` aligns the next object to a multiple of four bytes.
`.word` declares initial word values; `.space 4` reserves four bytes (zero-filled
by GNU assembler here). `.space` does not specify an element type.

The course reset handler copies `.data` initial values from Flash to RAM and
clears `.bss` before entering `main`. Restart the debug session to restore the
initial values before repeating an example.

`ldr r0, =value` is a GNU assembler pseudo-instruction that puts the **address**
of `value` in R0. `ldr r1, [r0]` reads the **contents** at that address.
`ldr r1, =0x12345678` instead loads a constant. Square brackets mean a memory
access. `LDRB` and `LDRH` zero-extend unsigned values to 32 bits.

## Guided examples

Predict the register and memory values first, then run these five examples.
Pause at `main`, step through the instructions, and stop at `stop`.

### Example 1 — Write one value to RAM

Build: `make PROJECT=examples/memory_store`. Step through each instruction.

```asm
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
```

R0 holds the address of `value`, R1 is 42, and the word at R0 becomes 42. In a byte view, the four bytes are `2A 00 00 00`.

### Example 2 — Read a word, byte, and halfword

Build: `make PROJECT=examples/memory_load_sizes`. Step through each instruction.

```asm
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
```

The bytes at increasing addresses are `78 56 34 12`. The least significant byte has the lowest address: this is little endian. R1 = `0x12345678`, R2 = `0x00000078`, R3 = `0x00005678`.

### Example 3 — Change individual bytes and halfwords

Build: `make PROJECT=examples/memory_store_sizes`. Step through each instruction.

```asm
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
```

Record the bytes after every store: `12 00 00 00`, `12 34 00 00`, `12 34 CD AB`, then `78 56 34 12`. `STRB` writes the low 8 bits, `STRH` the low 16 bits, and `STR` all 32 bits. Other bytes are preserved by the smaller stores.

### Example 4 — Addressing modes

Build: `make PROJECT=examples/memory_addressing`. Step through each instruction.

```asm
.syntax unified
.cpu cortex-m4
.thumb
.global main

.data
.balign 4
values:
    .word 10, 20, 30, 40

.text
.type main, %function
.thumb_func
main:
    ldr r0, =values
    ldr r1, [r0, #4]   @ R1 = 20; R0 stays at base
    ldr r2, [r0], #4   @ R2 = 10; R0 becomes base + 4
    ldr r3, [r0, #4]!  @ R3 = 30; R0 becomes base + 8

stop:
    nop
    b stop
.size main, .-main
```

These instructions run in sequence, so changes to R0 affect the next instruction.

| Instruction | Effective address | Loaded value | R0 afterward |
|---|---|---:|---|
| `ldr r1, [r0, #4]` | base + 4 | 20 | base |
| `ldr r2, [r0], #4` | base | 10 | base + 4 |
| `ldr r3, [r0, #4]!` | base + 8 | 30 | base + 8 |

Offset addressing leaves the base unchanged. Post-indexing accesses memory before updating the base; pre-indexing with `!` updates the base before accessing memory.

### Example 5 — Three variables in RAM

Build: `make PROJECT=examples/memory_variables`. Step through each instruction.

```asm
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
```

This is the bridge from Lab 1: the inputs and result now live in RAM. R1 = 42, R2 = 15, R3 = 57, and the word at `C` is 57.

## Required tasks

1. Run all five guided examples. Record the observations requested above.
2. Use the same variant as Lab 1, from the table below.
3. In `main.s`, reserve four bytes each for `A`, `B`, and `C` using `.space 4`.
4. Store X in A and Y in B using `STR`. Load them back using `LDR`, calculate
   `A + B` using `ADD`, and store the result in C. Do not calculate only from
   the original register inputs: read both operands from RAM.
5. Predict the sum and the four bytes of each variable in little endian order.
   Compare your predictions with the Memory View and registers.
6. Explain the difference between an address and its contents, and between
   offset, pre-indexed, and post-indexed addressing.

| Variant | X | Y |
|---|---:|---:|
| 1 | 42 | 15 |
| 2 | 52 | 18 |
| 3 | 85 | 27 |
| 4 | 100 | 37 |
| 5 | 96 | 28 |
| 6 | 78 | 23 |
| 7 | 120 | 45 |

Complete this table with the actual addresses reported by your debugger:

| Object | Address | Expected word | Expected bytes, lowest address first | Observed word |
|---|---|---|---|---|
| A | | | | |
| B | | | | |
| C | | | | |

## Debugging and submission

In Cortex-Debug, pause at `main`, execute `ldr r0, =A`, and use the address in
R0 to open a Memory View covering A, B, and C (12 bytes). Select a byte display
to inspect byte order. Step through the stores and loads, then pause at `stop`.
You can also use the Debug Console: `p/x &A`, `x/12bx &A`, and `x/3wx &A`
(prefix GDB commands with `-exec` when using Cortex-Debug).

Submit your commented `main.s`. Append a **Student report** section to this
README with your name, GitHub username, variant, predictions, completed table,
guided-example observations, answers, and a 2–3 sentence conclusion.
Preserve these instructions. Include `screenshots/debug_registers.png` and
`screenshots/debug_memory.png`, referenced from the report.

Open a PR from `lab02` to `master` in your own fork and send the instructor its
URL. Merge only after instructor approval, as described in the student workflow.
Do not commit generated build files.
