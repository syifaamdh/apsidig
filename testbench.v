
`timescale 1ns / 1ps

module testbench;

 // Outputs
    wire MR;
    wire MY;
    wire MG;
    wire SR;
    wire SY;
    wire SG;
    wire ST;
    
    // Inputs
    reg TS;
    reg TL;
    reg C;
    reg reset;
    reg Clk;

   

    // Instantiate the Unit Under Test (UUT)
    fsm uut (
        .MR(MR), 
        .MY(MY), 
        .MG(MG), 
        .SR(SR), 
        .SY(SY), 
        .SG(SG), 
        .ST(ST), 
        .TS(TS), 
        .TL(TL), 
        .C(C), 
        .reset(reset), 
        .Clk(Clk)
    );

    initial begin
        // Initialize Inputs
        TS = 0;
        TL = 0;
        C = 0;
        reset = 1;

        Clk = 0;
        #100; TS = 0; TL = 1; C = 1; reset = 0;
        #100; TS = 0; TL = 0; C = 0; reset = 1;
        #100; TS = 1; TL = 1; C = 0; reset = 0;
        #100;
    end
