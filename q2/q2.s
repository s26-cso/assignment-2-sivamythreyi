.section .rodata
fmt_first: .string "%d"      
fmt_space: .string " %d"     
fmt_nl:    .string "\n"      

.section .text
.globl main

main:
    addi sp, sp, -80
    sd ra, 72(sp)
    sd s0, 64(sp)
    sd s1, 56(sp)
    sd s2, 48(sp)
    sd s3, 40(sp)
    sd s4, 32(sp)
    sd s5, 24(sp)
    sd s6, 16(sp)
    sd s7, 8(sp)
    sd s8, 0(sp)
    mv s0, a0              # argc
    mv s1, a1              # argv
    addi s2, s0, -1        # number of elements (ignore program name)
    blez s2, only_newline  # if no input, just print newline
    slli a0, s2, 2         # allocate array for input (int = 4 bytes)
    call malloc
    mv s3, a0              # s3 = arr
    slli a0, s2, 2
    call malloc
    mv s4, a0              # s4 = result array

    slli a0, s2, 2
    call malloc
    mv s5, a0              # s5 = stack (stores indices)

    li s6, 0               # i = 0
read_loop:
    bge s6, s2, read_done  # loop till all inputs read

    addi t0, s6, 1
    slli t0, t0, 3         # argv[i+1] (each pointer = 8 bytes)
    add t0, s1, t0
    ld a0, 0(t0)           # load string
    call atoi              # convert to integer

    slli t1, s6, 2
    add t1, s3, t1
    sw a0, 0(t1)           # arr[i] = value

    addi s6, s6, 1
    j read_loop

read_done:
    li s6, -1              # stack top = -1 (empty)
    addi s7, s2, -1        # start from last index

process_outer:
    bltz s7, process_done  # if i < 0, done

    slli t0, s7, 2
    add t0, s3, t0
    lw t1, 0(t0)           # t1 = arr[i]

process_while:
    bltz s6, no_greater    # if stack empty

    slli t2, s6, 2
    add t2, s5, t2
    lw t3, 0(t2)           # top index from stack

    slli t4, t3, 2
    add t4, s3, t4
    lw t5, 0(t4)           # arr[stack.top]

    bgt t5, t1, found_greater  # if greater found
    addi s6, s6, -1            # pop stack
    j process_while

no_greater:
    slli t0, s7, 2
    add t0, s4, t0
    li t1, -1
    sw t1, 0(t0)           # result[i] = -1
    j push_index

found_greater:
    slli t0, s7, 2
    add t0, s4, t0
    sw t3, 0(t0)           # result[i] = index of next greater

push_index:
    addi s6, s6, 1         # push current index
    slli t0, s6, 2
    add t0, s5, t0
    sw s7, 0(t0)

    addi s7, s7, -1        # move left
    j process_outer

process_done:
    lw a1, 0(s4)           # print first element
    la a0, fmt_first
    call printf

    li s7, 1
print_loop:
    bge s7, s2, print_done

    slli t0, s7, 2
    add t0, s4, t0
    lw a1, 0(t0)           # load result[i]

    la a0, fmt_space
    call printf

    addi s7, s7, 1
    j print_loop

print_done:
    la a0, fmt_nl          # print newline
    call printf

    li a0, 0
    j main_done

only_newline:
    la a0, fmt_nl
    call printf
    li a0, 0

main_done:
    ld ra, 72(sp)
    ld s0, 64(sp)
    ld s1, 56(sp)
    ld s2, 48(sp)
    ld s3, 40(sp)
    ld s4, 32(sp)
    ld s5, 24(sp)
    ld s6, 16(sp)
    ld s7, 8(sp)
    ld s8, 0(sp)
    addi sp, sp, 80
    ret
    