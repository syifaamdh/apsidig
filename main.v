
`timescale 1ns / 1ps

module main(
    output MR,
    output MY,
    output MG,
    output SR,
    output SY,
    output SG,
    input reset,
    input C,
    input Clk
);
    
    timer part1(TS, TL, ST, Clk);
    fsm part2(MR, MY, MG, SR, SY, SG, ST, TS, TL, C, reset, Clk);
endmodule
`timescale 1ns / 1ps

