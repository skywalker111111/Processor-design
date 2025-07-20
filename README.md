项目结构概述
项目包含三个主要任务，每个任务都有对应的处理器实现和测试平台：
task1: 基础指令读取和译码
task2: 实现 IRMOV 指令并操作寄存器
task3: 扩展支持多种指令类型和寄存器读取

任务 1：基础指令读取和译码
文件列表
task1/tb.txt: 测试平台，用于验证指令读取和译码功能
task1/processor.txt: 处理器核心模块，包含基本指令处理逻辑

模块接口说明
processor 模块
module processor (
    input clock,               // 时钟信号
    input rst_n,               // 复位信号（低电平有效）
    input [8:0] addr,          // 存储器地址
    input wEn,                 // 写使能
    input [31:0] wDat,         // 写数据
    input working,             // 处理器使能信号
    output [3:0] icode,        // 指令码
    output [3:0] ifun,         // 功能码
    output [2:0] rA,           // 源寄存器A
    output [2:0] rB,           // 源寄存器B
    output [2:0] rd,           // 目的寄存器
    output [14:0] valC         // 立即数
);

tb 测试平台
测试流程：
写入 3 条指令到内存
启动处理器并监控译码输出
验证 icode、ifun、rA、rB、rd 和 valC 信号

任务 2：实现 IRMOV 指令并操作寄存器
文件列表
task2/tb.txt: 测试平台，验证 IRMOV 指令执行
task2/processor.txt: 处理器核心，实现 IRMOV 指令逻辑
task2/regfile.txt: 寄存器堆模块，支持寄存器读写

模块接口说明
processor 模块
module processor(
    input clock,        // 时钟信号
    input reset,        // 复位信号（高电平有效）
    input [8:0] addr,   // 读写地址
    input wr,           // 写使能信号
    input [31:0] wdata, // 写入数据
    input working,      // 处理器使能信号
    output [31:0] r0-r7, // 8个通用寄存器
    output [3:0] icode,  // 指令码
    output [3:0] ifun,   // 功能码
    output [2:0] rA,     // 源寄存器A
    output [2:0] rB,     // 源寄存器B
    output [2:0] rd,     // 目的寄存器
    output [14:0] valC   // 立即数
);

regfile 模块
module regfile(
    input [3:0] dstE,    // 写入端口E的目标寄存器ID
    input [31:0] valE,   // 写入端口E的值
    input [3:0] dstM,    // 写入端口M的目标寄存器ID
    input [31:0] valM,   // 写入端口M的值
    input reset,         // 同步复位信号
    input clock,         // 时钟信号
    output [31:0] r0-r7, // 8个通用寄存器
    input [2:0] rAddr1,  // 读取地址1
    input [2:0] rAddr2,  // 读取地址2
    output [31:0] rData1, // 读取数据1
    output [31:0] rData2  // 读取数据2
);

tb 测试平台
测试流程：
写入 4 条 IRMOV 指令到内存，分别将学号相关值加载到 r0-r3
启动处理器并监控寄存器值变化
验证寄存器是否正确加载了立即数

任务 3：扩展支持多种指令类型和寄存器读取
文件列表
task3/tb.txt: 测试平台，验证多种指令执行
task3/processor.txt: 处理器核心，扩展指令支持
task3/regfile.txt: 改进的寄存器堆，支持时序读取
task3/ram.txt: 存储器模块

模块接口说明
processor 模块
module processor (
    input clock,               // 时钟信号
    input rst_n,               // 复位信号（低电平有效）
    input [8:0] addr,          // 存储器地址
    input wEn,                 // 写使能
    input [31:0] wDat,         // 写数据
    input working,             // 处理器使能信号
    output [31:0] r0-r7,       // 8个通用寄存器
    output [3:0] icode,        // 指令码
    output [3:0] ifun,         // 功能码
    output [2:0] rA,           // 源寄存器A
    output [2:0] rB,           // 源寄存器B
    output [2:0] rd,           // 目的寄存器
    output [14:0] valC,        // 立即数
    output [31:0] valA,        // 源寄存器A的值
    output [31:0] valB         // 源寄存器B的值
);

regfile 模块
改进了寄存器读取逻辑，采用时序逻辑避免竞争冒险：
module regfile(
    input [3:0] dstE,      // 写入端口E的目标寄存器ID
    input [31:0] valE,     // 写入端口E的值
    input [3:0] dstM,      // 写入端口M的目标寄存器ID
    input [31:0] valM,     // 写入端口M的值
    input [2:0] rAddr1,    // 读取地址1
    input [2:0] rAddr2,    // 读取地址2
    output reg [31:0] rData1,  // 读取数据1
    output reg [31:0] rData2,  // 读取数据2
    input reset,           // 同步复位信号
    input clock,           // 时钟信号
    output [31:0] r0-r7    // 8个通用寄存器
);

tb 测试平台
测试流程：
写入 4 条不同类型的指令到内存（IRMOV、ADD、SLL、SUB）
启动处理器并监控译码输出和寄存器值
验证不同指令的执行结果和寄存器读取功能

仿真说明
所有测试平台均采用相同的两阶段操作模式：
写入阶段 (working=0)：将指令写入内存
执行阶段 (working=1)：处理器从内存读取指令并执行
每个任务的测试平台都包含详细的监控代码，用于验证关键信号和寄存器值的变化。

任务 4：实现执行操作及算术逻辑指令
文件列表
task4/
├── alu.txt       # 算术逻辑单元（ALU）
├── processor.txt # 处理器核心模块（含译码、执行、写回逻辑）
├── ram.txt       # 指令存储器
├── regfile.txt   # 寄存器堆模块
└── tb.txt        # 测试平台（验证5条指令执行）

模块接口说明
1. alu.txt（算术逻辑单元）
module alu(
    input [31:0] aluA,   // 操作数A（寄存器值或立即数）
    input [31:0] aluB,   // 操作数B（寄存器值或移位量）
    input [3:0] alufun,  // 运算功能码（0-3）
    output reg [31:0] valE  // 运算结果
);
// 支持加法、减法、逻辑或、逻辑左移（aluB低5位为移位量）
2. processor.txt（处理器核心）
module processor (
    input clock, rst_n, working,
    input [8:0] addr, wEn,
    input [31:0] wDat,
    output [3:0] icode, ifun,
    output [2:0] rA, rB, rd,
    output [14:0] valC,
    output [31:0] r0-r7, valA, valB, valE
);
// 集成取指、译码、执行、写回全流程
// 新增ALU接口，支持5条指令的执行逻辑
3. regfile.txt（寄存器堆）
module regfile(
    input [3:0] dstE, dstM,    // 写端口寄存器ID（ALU/IRMOV）
    input [31:0] valE, valM,   // 写端口数据（ALU结果/立即数）
    input [2:0] rAddr1, rAddr2, // 读端口寄存器ID
    output [31:0] rData1, rData2, // 读端口数据
    input reset, clock,
    output [31:0] r0-r7
);
// 支持双端口读、双端口写，同步复位
4. ram.txt（指令存储器）
module ram(
    input clock, rst_n,
    input [8:0] addr, wEn, rEn,
    input [31:0] wDat,
    output [31:0] rDat
);
// 9位地址空间，32位数据总线，同步读写

tb 测试平台
测试流程：
写入阶段（working=0）：向地址 0-7 写入 8 条指令：
4 条 IRMOV 指令（加载学号0xCAF6及增量值到 r0-r3）
1 条 ADD 指令（r4 = r1 + r2）
1 条 SUB 指令（r5 = r0 - r3）
1 条 OR 指令（r6 = r1 | r0）
1 条 SLL 指令（r7 = r2 << 3）
执行阶段（working=1）：运行 12 个时钟周期，验证：
寄存器 r0-r3 是否正确加载立即数
ALU 指令结果（valE）是否与预期一致（如 r4=0x195EF，r7=0x65FC0）
写回逻辑是否正确更新寄存器堆

仿真说明：
关键信号监控：
icode/ifun：验证指令类型解析（如 ADD=2，SLL=3）
valA/valB：确认寄存器读取值正确
valE：观察 ALU 运算过程（如减法结果为补码 - 3）
r0-r7：确保指令执行后寄存器值符合预期

任务 5：四级流水线处理器的实现
文件列表
task5/
├── processor.txt   # 流水线处理器核心（含冒险处理）
├── regfile.txt     # 寄存器堆（支持流水线写回）
├── ram.txt         # 指令存储器（与任务4共用）
└── tb.txt          # 流水线测试平台（验证指令执行与冒险处理）

模块接口说明
1. processor.txt：流水线处理器核心
module processor (
    input        clock,       // 时钟信号（50MHz，周期20ns）
    input        rst_n,       // 复位信号（低电平有效，同步复位）
    input [8:0]  addr,        // 存储器写地址（仅在写入阶段使用）
    input        wEn,         // 存储器写使能（working=0时有效）
    input [31:0] wDat,        // 存储器写数据
    input        working,     // 处理器使能（高电平启动流水线）
    
    // 指令解析输出（调试观测）
    output [3:0]  icode,      // 指令码（IF阶段）
    output [3:0]  ifun,       // 功能码（IF阶段）
    output [2:0]  rA, rB,     // 源寄存器（ID阶段）
    output [2:0]  rd,         // 目标寄存器（ID阶段）
    output [14:0] valC,       // 立即数（ID阶段）
    
    // 寄存器值输出
    output [31:0] r0, r1, r2, r3, r4, r5, r6, r7, // 8个通用寄存器
    
    // 内部信号（调试观测）
    output [31:0] valA, valB, // 译码阶段寄存器值
    output [31:0] valE,       // 执行阶段ALU结果
    output [8:0]   pc          // 当前PC值
);

核心功能：

四级流水线：
IF（取指）：从存储器读取 32 位指令，PC 自动递增（PC+1）。
ID（译码）：解析指令字段，读取寄存器值，处理数据冒险前递。
EX（执行）：ALU 运算（加法、减法、逻辑或、逻辑左移）。
WB（写回）：将结果写入寄存器堆。
数据冒险处理：
通过前递（Forwarding）机制解决 RAW 冒险，将 EX 阶段结果直接传递至 ID 阶段。
检测条件：当前指令源寄存器（rA/rB）与前一条指令目标寄存器（EX_WB_rd）匹配时，使用前递值fwd_valA/fwd_valB。
2. regfile.txt：流水线寄存器堆
module regfile (
    input [3:0]  dstE,    // EX阶段目标寄存器（ALU指令，3位）
    input [31:0] valE,    // EX阶段结果（ALU运算值）
    input [3:0]  dstM,    // WB阶段目标寄存器（IRMOV指令，3位）
    input [31:0] valM,    // WB阶段数据（IRMOV立即数）
    input [2:0]  rAddr1,  // 源寄存器A地址（ID阶段读取）
    input [2:0]  rAddr2,  // 源寄存器B地址（ID阶段读取）
    output [31:0] rData1, // 源寄存器A值（组合逻辑输出）
    output [31:0] rData2, // 源寄存器B值（组合逻辑输出）
    input        reset,   // 同步复位（高电平有效，清零所有寄存器）
    input        clock    // 时钟信号
);
特性：

双端口写：支持 ALU 指令（dstE/valE）和 IRMOV 指令（dstM/valM）同步写回。
组合逻辑读：ID 阶段直接读取寄存器值，支持冒险检测中的前递逻辑。
tb 测试平台说明
测试流程：
写入阶段（working=0, wEn=1）：向存储器写入 8 条指令：
// 指令0-3：IRMOV加载学号0xCAF6及增量值（学号后四位CAF6）
addr=0; wDat=32'b0001_0000_000_000_000_1100101011110110; // r0=0xCAF6
addr=1; wDat=32'b0001_0000_000_000_001_1100101011110111; // r1=0xCAF7
addr=2; wDat=32'b0001_0000_000_000_010_1100101011111000; // r2=0xCAF8
addr=3; wDat=32'b0001_0000_000_000_011_1100101011111001; // r3=0xCAF9

// 指令4：ADD r3, r1, r2（目标寄存器r3，与指令5存在RAW冒险）
addr=4; wDat=32'b0010_0000_001_010_011_000000000000000; 

// 指令5：SUB r6, r0, r3（源寄存器r3为指令4的目标寄存器）
addr=5; wDat=32'b0010_0001_000_011_110_000000000000000; 

// 指令6：OR r5, r0, r6
addr=6; wDat=32'b0011_0000_000_110_101_000000000000000; 

// 指令7：SLL r7, r1, $3（逻辑左移3位）
addr=7; wDat=32'b0011_0001_001_000_111_000000000000011; 

执行阶段（working=1, wEn=0）：运行 16 个时钟周期，验证：
流水线阶段：观察 PC 递增、指令按 IF→ID→EX→WB 流动。
冒险处理：指令 5 通过前递获取指令 4 的 ALU 结果，避免流水线停顿。
寄存器值：
r3=0x195EF（0xCAF7+0xCAF8），r6=0xFF7A0D07（0xCAF6-0x195EF，补码）。
r7=0x65FC0（0xCAF8 << 3）。
关键信号监控：
流水线寄存器：IF_ID_instr（取指结果）、ID_EX_valA（译码阶段寄存器值）、EX_WB_valE（执行结果）。
冒险信号：fwd_valA、fwd_valB（前递值），确认在冒险发生时有效。
PC 与指令流：确保每个周期 PC 递增 1，指令按地址顺序执行。

仿真说明
工具与时钟：
推荐工具：Vivado/ModelSim
时钟周期：20ns（50MHz），通过#10翻转时钟。
两阶段模式：
写入阶段：working=0，通过addr/wEn/wDat向存储器写入指令。
执行阶段：working=1，处理器自动取指并执行，无需手动操作地址。
验证重点：
流水线各阶段信号是否按周期正确传递。
数据冒险是否通过前递机制消除，寄存器值是否与预期一致。# Processor-design
