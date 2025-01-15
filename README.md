# RV32I implementation

This is a RV32I core implemented with the intention of running within an Xilinx Spartan-7 FPGA

## This is a WIP (currently single-cycle), currently working on:
    - Implementing a 2-way set associative cache
    - Pipelining

## To build tb with Verilator:
    - cd build
    - bash run_tb.sh
    - ./obj_dir/Vtb_basic