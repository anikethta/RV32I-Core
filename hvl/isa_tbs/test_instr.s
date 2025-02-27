# test RV32I asm code
# following code executes various random instructions, not previously tested

_start:
    addi t0, zero, 25
    sb t0, 96(zero)
    lbu t1, 96(zero)
    xori t2, t1, -1
    addi t2, t2, 1
    ble t2, t0, target # if t0 <= t1 then target
    addi t2, t2, 25 # should not be taken

target:
    auipc t3, 0 // t3 = PC
    lui t4, 0x00001 // t4 = 0x00001000
    sw t4, 84(zero)
    jalr t3, 0

