# Basic RV32I CPU
Some key directories are shown below.
```
|--rom_src/         ## Assembly source code
|--src/             ## Verilog source code
  |--rom/
    |--program.hex  ## Program to be loaded into the Instruction Memory
|--test/            ## Testbench to run the simulation
|--Makefile         ## Makefile for building and running sim targets
```

## Dependencies
- Simulator: [Verilator](https://www.veripool.org/wiki/verilator)
- Assembler: [RV32IAS](https://github.com/davidli218/rv32ias)

## Getting Started
```bash
$ git clone https://github.com/davidli218/basic-rv32i-cpu
$ cd basic-rv32i-cpu/
$ make
```
