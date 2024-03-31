# [Fibonacci Sequence] & [3 Magic Int] Generator
#
# Fibonacci Sequence:
#     fib(0) = 0
#     fib(1) = 1
#     fib(n) = fib(n-1) + fib(n-2)
#
# 3 Magic Int:
#     1. 0x7FFFFFFF
#     2. 0x0000000F
#     3. 0x000000F0
#
# Register Usage:
#     s0: fib_n
#     s1: fib_array_addr
#     s2: magic_int_n
#     s3: magic_int_addr


# Read input from CPU_IN
    lw   s0, 0xFFFFFFFC(zero)             # fib_n = input()

# Initialize Stack Pointer
    addi sp, zero, 499                    # Stack Top is 499

# Initialize S Registers
    andi s0, s0,   0xF                    # fib_n = fib_n > 15 ? 15 : fib_n
    addi s1, zero, 600                    # fib_array_addr = 600
    addi s2, zero, 3                      # magic_int_n = 3
    addi s3, zero, 700                    # magic_int_addr = 700

# Call fib(fib_n, fib_array_addr)
    add  a0, zero, s0
    add  a1, zero, s1
    jal  ra, fib

# Call output_array(fib_array_addr, fib_n)
    add  a0, zero, s1
    add  a1, zero, s0
    jal  ra, output_array

# Call load_3magic_int(magic_int_addr)
    add  a0, zero, s3
    jal  ra, load_3magic_int

# Call output_array(magic_int_addr, magic_int_n)
    add  a0, zero, s3
    add  a1, zero, s2
    jal  ra, output_array

# Call exit()
    jal  ra, exit


# func fib(int n, int* result_array_addr) -> void
fib:
    addi t1, zero, 0                      # i = 0
    add  t2, zero, a1                     # mem_addr = result_array_addr

    addi t3, zero, 1                      # fib_temp_1 = 1
    addi t4, zero, 1                      # fib_temp_2 = 1
    add  t5, zero, zero                   # fib_temp_3 = 0

fib_loop:
    slt  t0, t1,   a0                     # temp = i < n
    beq  t0, zero, fib_end                # if !temp, then goto fib_end

    add  t5, t3,   t4                     # fib_temp_3 = fib_temp_1 + fib_temp_2
    sw   t3, 0(t2)                        # mem[mem_addr] = fib_temp_1

    add  t3, t4, zero                     # fib_temp_1 = fib_temp_2
    add  t4, t5, zero                     # fib_temp_2 = fib_temp_3

    addi t1, t1, 1                        # i++
    addi t2, t2, 4                        # mem_addr += 4

    jal  t5, fib_loop                     # goto fib_loop

fib_end:
    jalr t0, 0(ra)                        # return


# func output_array(int* array_addr, int length) -> void
output_array:
    addi t1, zero, 0                      # i = 0
    add  t2, zero, a0                     # mem_ptr = result_array_addr

output_array_loop:
    slt  t0, t1,   a1                     # temp = i < n
    beq  t0, zero, output_array_end       # if !temp, then goto print_array_end

    lw   t0,   0(t2)                      # temp = mem[mem_ptr]
    sw   zero, 0xFFFFFFFC(zero)           # output(0)
    sw   t0,   0xFFFFFFFC(zero)           # output(temp)

    addi t1, t1, 1                        # i++
    addi t2, t2, 4                        # mem_ptr += 4

    jal  t5, output_array_loop            # goto print_array_loop

output_array_end:
    jalr t5, 0(ra)                        # return


# func load_3magic_int(dest_array_addr)
load_3magic_int:
    sw   ra, 0(sp)                        # push ra
    addi sp, sp, -4                       # sp -= 4
    sw   a0, 0(sp)                        # push arg0: dest_array_addr
    addi sp, sp, -4                       # sp -= 4

    jal  ra, load_max_int32               # call load_max_int32()

    add  t1, zero, a0                     # t1 = 0x7FFFFFFF
    addi t2, zero, 0x00F                  # t2 = 0x00F
    addi t3, zero, 0x0F0                  # t3 = 0x0F0

    addi sp, sp, 4                        # sp += 4
    lw   a0, 0(sp)                        # pop arg0: dest_array_addr
    addi sp, sp, 4                        # sp += 4
    lw   ra, 0(sp)                        # pop ra

    and  t4, t1, t2                       # t4 = 0x00F
    or   t5, t4, t3                       # t5 = 0x0FF
    sub  t5, t5, t2                       # t5 = 0x0F0

    sw   t1, 0(a0)                        # mem[array_addr] = 0x7FFFFFFF
    sw   t4, 4(a0)                        # mem[array_addr + 4] = 0x0000000F
    sw   t5, 8(a0)                        # mem[array_addr + 8] = 0x000000F0

    jalr t0, 0(ra)                        # return


# func load_max_int32() -> int
load_max_int32:
    lui  a0, 0x7FFFF
    ori  a0, a0, 0x7FF
    addi a0, a0, 0X7FF
    addi a0, a0, 1
    jalr t0, 0(ra)                        # return 0x7FFFFFFF


# func exit()
exit:
    jal  t0, exit                         # end
