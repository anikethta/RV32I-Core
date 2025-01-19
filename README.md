# RV32I implementation

This is a RV32I core implemented with the intention of running within an Xilinx Spartan-7 FPGA <br />
\n However, porting this to a FPGA will take a while...

## This is a WIP (currently single-cycle), currently working on:
    - Finish L1 Data Cache, Pseudo-LRU implementation
    - Pipelining

## To build tb with Verilator:
    - cd build
    - bash run_tb.sh
    - ./obj_dir/V[selected tb file]