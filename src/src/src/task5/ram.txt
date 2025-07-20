`timescale 1ns/1ps
module ram (
    input clock,               // 时钟信号
    input rst_n,
    input [8:0] addr,         // 读写地址
    input wEn,                 // 写使能
    input [31:0] wDat,         // 写数据
    input rEn,                 // 读使能
    output reg [31:0] rDat     // 读数据
);

    localparam ZERO_DATA = 32'b0;
    localparam ZERO_ADDR = 9'b0;
    
    reg [31:0] memory [0:255];
    
    integer i;
    always @(posedge clock or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 256; i = i + 1) memory[i] <= ZERO_DATA;
        end
        else if (wEn) memory[addr] <= wDat;
    end

    always @(posedge clock or negedge rst_n) begin
        if(!rst_n) rDat <= ZERO_DATA;
        else if(rEn) rDat <= memory[addr];
        else rDat <= ZERO_DATA;
    end

endmodule