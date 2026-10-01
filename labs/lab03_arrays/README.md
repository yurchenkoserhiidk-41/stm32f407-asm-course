# Practical Work 3 — Arrays and Block Data Transfer

Work in `labs/lab03_arrays/` on branch `lab03` in your personal fork.
Follow the [student workflow](../../docs/student-workflow.md).
Build from the repository root: `make PROJECT=labs/lab03_arrays`.
Complete Lab 2 first.

## Goal

Declare arrays, calculate element addresses, read and write elements, and walk
through a word array using post-indexed addressing. `LDM/STM` are an optional
extension after the required work.

## Array addressing

Array indices start at zero. The offset is measured in **bytes**:

```text
address(array[i]) = base_address + i × element_size
```

| Declaration | Element size | Offset of element 2 | Load / store |
|---|---:|---:|---|
| `.byte` | 1 byte | 2 | `LDRB / STRB` |
| `.hword` | 2 bytes | 4 | `LDRH / STRH` |
| `.word` | 4 bytes | 8 | `LDR / STR` |

Use `.balign 2` before halfword arrays and `.balign 4` before word arrays,
especially after byte arrays. For this lab, all elements are unsigned.

## Guided examples

Each listing is a complete, separately buildable project. Predict the results,
step through the code, and inspect both registers and memory.

### Example 1 — Read a word array

Build: `make PROJECT=examples/array_word_read`. Step through each instruction.

```asm
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
    ldr r1, [r0, #8]   @ numbers[2] = 30

stop:
    nop
    b stop
.size main, .-main
```

R1 = 30. `numbers[2]` is eight bytes after the base, because each word occupies four bytes.

### Example 2 — Write an array element

Build: `make PROJECT=examples/array_word_write`. Step through each instruction.

```asm
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
```

The array becomes `10, 20, 30, 42, 50`. Element 3 has byte offset 12.

### Example 3 — Read a byte array

Build: `make PROJECT=examples/array_byte_read`. Step through each instruction.

```asm
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
```

R1 = 30. Compare `numbers[2]` at offset 8 with `bytes[2]` at offset 2. Explain why the same index requires different offsets.

### Example 4 — Advance a pointer

Build: `make PROJECT=examples/array_pointer_iteration`. Step through each instruction.

```asm
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
    ldr r1, [r0], #4   @ R1 = 10; R0 = base + 4
    ldr r2, [r0], #4   @ R2 = 20; R0 = base + 8
    ldr r3, [r0], #4   @ R3 = 30; R0 = base + 12

stop:
    nop
    b stop
.size main, .-main
```

R1 = 10, R2 = 20, R3 = 30. Record R0 after each load. This is three unrolled steps of pointer iteration; no branch-based loop is required.

## Required tasks

Use your Lab 1 variant number V (1–7). Define the five values as follows:

| Element | Initial value |
|---|---|
| 0 | 10 + V |
| 1 | 20 + V |
| 2 | 30 + V |
| 3 | 40 + V |
| 4 | 50 + V |

The replacement value is `100 + V`. For example, variant 1 uses
`11, 21, 31, 41, 51` and replacement 101. All values fit in an unsigned byte.

1. Declare a `.word` array `numbers` with your five values.
2. Load `numbers[0]`, `numbers[2]`, and `numbers[4]` into R1, R2, and R3.
3. Replace `numbers[3]` with your replacement value using `STR`.
4. Declare a `.byte` array `bytes` with the same initial values. Load elements
   0, 2, and 4 into R4, R5, and R6 using `LDRB`, then replace element 3 using
   `STRB`. Preserve R1–R6 for the final screenshot.
5. Complete an address table for **all five elements of both arrays**. Include
   element size, index, byte offset, and actual address from the debugger.
6. Repeat the three pointer loads from Example 4. Record the loaded values and
   pointer after each instruction (a separate debug run is acceptable).
7. Explain why `.byte` elements advance by 1 byte, `.hword` by 2 bytes, and
   `.word` by 4 bytes. Calculate the offset of element 3 of a halfword array.

Table format (replace the symbolic addresses with actual debugger addresses):

| Element | Index | Size (bytes) | Offset (bytes) | Address |
|---|---:|---:|---:|---|
| `numbers[0]` | 0 | 4 | 0 | base |
| `numbers[1]` | 1 | 4 | 4 | base + 4 |
| `numbers[2]` | 2 | 4 | 8 | base + 8 |

## Optional advanced task — `LDM/STM`

### Example 5 — Block data transfer

Build: `make PROJECT=examples/array_block_transfer`. Step through each instruction.

```asm
.syntax unified
.cpu cortex-m4
.thumb
.global main

.data
.balign 4
numbers:
    .word 10, 20, 30, 40, 50
copy:
    .space 16

.text
.type main, %function
.thumb_func
main:
    ldr r0, =numbers
    ldm r0, {r1-r3}    @ R1 = 10, R2 = 20, R3 = 30; no write-back
    ldm r0, {r1-r4}    @ R4 = 40; R0 still equals base
    ldr r0, =copy
    stm r0, {r1-r4}    @ Copy four words; R0 stays unchanged

stop:
    nop
    b stop
.size main, .-main
```

The first `LDM` loads the same three words as Example 4, but leaves R0 unchanged. The second loads four words, which `STM` writes to `copy`. Registers are mapped in increasing register-number order to increasing word addresses. Use aligned word addresses; these instructions do not transfer byte or halfword elements. With `ldm r0!, {r1-r4}` or `stm r0!, {r1-r4}`, R0 advances by 16 bytes. Keep the base register out of the transfer list when using write-back.

Compare `ldm r0, {r1-r4}` with four `LDR` instructions using offsets 0, 4, 8,
and 12, and `stm r0, {r1-r4}` with four corresponding `STR` instructions.
Then compare the write-back versions with four post-indexed loads/stores.
Record final register values, destination words, and base-pointer values.
The required array tasks must work without `LDM/STM`.

## Debugging and submission

Use the address loaded into the base register to open each array in Memory
View: 20 bytes for `numbers`, 5 bytes for `bytes`. Inspect byte order as well
as element values. Useful GDB commands are `x/5uw &numbers` and `x/5ub &bytes`
(prefix with `-exec` in the Cortex-Debug Debug Console).
Restart the debug session before rerunning to restore initial array contents.

Submit commented `main.s` and append a **Student report** to this README with
name, GitHub username, variant, initial/replacement values, complete address
tables, expected and observed register values, pointer observations, answers,
and a 2–3 sentence conclusion. Preserve the instructions.
Include and reference `screenshots/debug_registers.png` and
`screenshots/debug_memory.png`; add a second memory screenshot if needed to
show both arrays. Identify any optional work separately.

Open a PR from `lab03` to `master` in your own fork and send the instructor its
URL. Merge only after instructor approval, following the student workflow.
Do not commit generated build files.
