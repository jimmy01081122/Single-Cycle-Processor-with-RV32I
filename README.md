# Single-Cycle-Processor-with-RV32I
專題增修，嘗試進行pipline和以此練習vivado

```
CA
├─ README.md
├─ alu
│  ├─ a.out
│  ├─ alu.v
│  └─ alu_tb.v
├─ branch
│  ├─ a.out
│  ├─ branch.v
│  └─ branchtb.v
├─ command.txt
├─ ctr
│  ├─ a.out
│  ├─ ctr.v
│  └─ ctrtb.v
├─ imm
│  ├─ a.out
│  ├─ imm.v
│  └─ immtb.v
├─ instrM
│  ├─ a.out
│  ├─ instrM.v
│  ├─ instrtb.v
│  └─ instructions.mem
├─ mem
│  ├─ a.out
│  ├─ mem.v
│  └─ memtb.v
├─ pc
│  ├─ a.out
│  ├─ pc.v
│  ├─ pctb.v
│  └─ testbench.vcd
└─ reg
   ├─ a.out
   ├─ reg.v
   └─ regtb.v
        +--------------------+
        | Program Counter (PC)|
        +--------------------+
                 |
                 v
        +--------------------+
        |  Instruction Memory |
        +--------------------+
                 |
                 v
        +--------------------+
        |  Instruction Decoder |
        +--------------------+
       /         |            \
      /          |             \
     /           |              \
+----+     +------------+   +------------+
| Reg |<-->| ALU Control |   | Imm Gen   |
| File|     +------------+   +------------+
+----+          |                  |
    |           v                  v
    |      +------------+       +------------+
    |      |    ALU     |<----->|    MUX     |
    |      +------------+       +------------+
    |             |                    |
    |             v                    v
    |      +------------+        +------------+
    |      |  Data Mem  |        | Branch CMP |
    |      +------------+        +------------+
    |             |                    |
    |             v                    v
    |       +------------+        +------------+
    |       |    MUX     |        |    MUX     |
    |       +------------+        +------------+
    |             |                    |
    |             v                    v
    +-------------> PC Update (Next PC) ----> Loop back to PC

```