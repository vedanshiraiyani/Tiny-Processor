<h2>FPGA implementation of the Complete “Tiny” Processor Design which runs one program.</h2>

The following processor has a register file consisting of 16 registers each of 8 bit. The processor
can execute the following instructions. The instructions that need 2 operands will take one of the
operand from the Register file and another from the accumulator. The result will be transferred to
Accumulator. There is an 8-bit extended (EXT) register used only during multiplication and
division operation. This register stores the higher order bits during multiplication and quotient
during division. The C/B register holds the carry and borrow during addition and subtraction,
respectively.
Note:
- Each instruction takes 1 clock cycle.
- Division operation can never have the 0 as divisor.
- Branch instruction can only branch within the program.

![image](https://github.com/vedanshiraiyani/Tiny-Processor/assets/117573771/ab163796-53b4-4457-ad77-26bb0f42f91e)

![image](https://github.com/vedanshiraiyani/Tiny-Processor/assets/117573771/c516cc82-c3e2-4f3d-a5f2-bc37df1a0cc9)

![image](https://github.com/vedanshiraiyani/Tiny-Processor/assets/117573771/b962787d-3cba-4083-9b74-9d3112c0ddb2)
