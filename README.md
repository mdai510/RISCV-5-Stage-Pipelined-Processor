# RISCV-5-Stage-Pipelined-Processor  
RISCV RV32I ISA basic implementation (no M, A, F, C RISCV extensions)  
Implemented R, I, S, B, U, J type instructions:
- register arithmetic & logic
- immediate arithmetic & logic
- loads / stores
- control flow (braches/jumps)
- upper immediate (lui, auipc)
- EBREAK 

Standard 5-stage pipeline:  
Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), Memory Access (MEM), Write Back (WB)  

Features: 
- Operand forwarding (EX-EX and MEM-EX)
- Branch prediction (predict not-taken), with IF/ID stage flushing for jumps/taken branches
- Pipeline stall for load-use hazards only 
 
Schematic (click to zoom in):  
<img width="4828" height="1990" alt="image" src="https://github.com/user-attachments/assets/d594166a-6bf4-4787-b360-ce9a5b857157" /> 

Based on/improved from this single cycle processor: https://github.com/mdai510/RISCV-Single-Cycle-Processor 
