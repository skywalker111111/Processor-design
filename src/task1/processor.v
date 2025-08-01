module processor(
    input clock,        // 时钟信号
    input reset,        // 复位信号
    input [8:0] addr,   // 读写地址
    input wr,           // 写使能信号
    input [31:0] wdata, // 写入数据
    input working,      // 处理器使能信号
    output [31:0] r0,   // 寄存器%r0
    output [31:0] r1,   // 寄存器%r1
    output [31:0] r2,   // 寄存器%r2
    output [31:0] r3,   // 寄存器%r3
    output [31:0] r4,   // 寄存器%r4
    output [31:0] r5,   // 寄存器%r5
    output [31:0] r6,   // 寄存器%r6
    output [31:0] r7,   // 寄存器%r7
    output [3:0] icode, // 指令码（调试用）
    output [3:0] ifun,  // 功能码（调试用）
    output [2:0] rA,    // 源寄存器A（调试用）
    output [2:0] rB,    // 源寄存器B（调试用）
    output [2:0] rd,    // 目的寄存器（调试用）
    output [14:0] valC, // 立即数（调试用）
    output [31:0] valA, // 源寄存器A的值（rs1）
    output [31:0] valB  // 源寄存器B的值（rs2）
);
    // 常量定义
    localparam ZERO_DATA = 32'b0;
    localparam ZERO_ADDR = 9'b0;
    
    // 内部信号
    reg [8:0] pc;               // 程序计数器
    wire [31:0] instruction;    // 当前指令
    wire [3:0] dstM;            // 写回目标寄存器（扩展为4位）
    wire [31:0] valM;           // 写回数据
    
    // RAM接口信号
    reg [8:0] ram_addr;
    wire ram_rEn;
    
    // 实例化RAM模块
    ram u_ram (
       .clock(clock),
       .addr(ram_addr),
       .wEn(wr),
       .wDat(wdata),
       .rEn(ram_rEn),
       .rDat(instruction)
    );
    
    // 实例化寄存器堆
    regfile u_regfile (
       .dstE(4'b0),           // 任务2中不使用
       .valE(32'b0),          // 任务2中不使用
       .dstM({1'b0, rd}),      // 使用rd作为目标寄存器
       .valM(valM),           // 零扩展后的立即数
       .reset(reset),
       .clock(clock),
       .r0(r0),
       .r1(r1),
       .r2(r2),
       .r3(r3),
       .r4(r4),
       .r5(r5),
       .r6(r6),
       .r7(r7),
       .rAddr1(rA),
       .rAddr2(rB),
       .rData1(valA),
       .rData2(valB)
    );
    
    // RAM地址选择逻辑
    always @(*) begin
        if(working == 1'b0 && wr == 1'b1) 
            ram_addr = addr;    // 写入模式使用外部地址
        else 
            ram_addr = pc;      // 执行模式使用PC
    end
    
    assign ram_rEn = working;   // 执行模式时启用读取
    
    // PC更新逻辑
    always @(posedge clock or posedge reset) begin
        if(reset) 
            pc <= ZERO_ADDR;
        else if(working) 
            pc <= pc + 1;      // 每个周期PC+1（固定4字节指令）
    end
    
    // 指令解码
    assign icode = instruction[31:28]; // 操作码
    assign ifun  = instruction[27:24]; // 功能码
    assign rA    = instruction[23:21]; // 寄存器A
    assign rB    = instruction[20:18]; // 寄存器B
    assign rd    = instruction[17:15]; // 目标寄存器
    assign valC  = instruction[14:0];  // 立即数
    
    // IRMOV指令处理
    assign valM = (icode == 4'b0001)? {17'b0, valC} : 32'b0; // 立即数零扩展
endmodule