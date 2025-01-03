`timescale 1ns / 1ps

module traffic_control(
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
    // Internal Signals
    wire TS, TL, ST;

    // Timer Submodule
    reg [3:0] value;
    assign TS = (value >= 4);
    assign TL = (value >= 14);

    always @(posedge ST or posedge Clk) begin
        if (ST == 1) begin
            value <= 0;
        end else begin
            value <= value + 1;
        end
    end

    // FSM Submodule
    reg [6:1] state;
    reg internal_ST;

    parameter mainroadgreen = 6'b001100;
    parameter mainroadyellow = 6'b010100;
    parameter sideroadgreen = 6'b100001;
    parameter sideroadyellow = 6'b100010;

    assign MR = state[6];
    assign MY = state[5];
    assign MG = state[4];
    assign SR = state[3];
    assign SY = state[2];
    assign SG = state[1];
    assign ST = internal_ST;

    initial begin
        state = mainroadgreen;
        internal_ST = 0;
    end

    always @(posedge Clk) begin
        if (reset) begin
            state <= mainroadgreen;
            internal_ST <= 1;
        end else begin
            internal_ST <= 0;
            case (state)
                mainroadgreen:
                    if (TL & C) begin
                        state <= mainroadyellow;
                        internal_ST <= 1;
                    end
                mainroadyellow:
                    if (TS) begin
                        state <= sideroadgreen;
                        internal_ST <= 1;
                    end
                sideroadgreen:
                    if (TL | !C) begin
                        state <= sideroadyellow;
                        internal_ST <= 1;
                    end
                sideroadyellow:
                    if (TS) begin
                        state <= mainroadgreen;
                        internal_ST <= 1;
                    end
            endcase
        end
    end

endmodule

// Testbench
module testbench;
    wire MR, MY, MG, SR, SY, SG, ST;
    reg C, reset, Clk;

    // Instantiate the design under test (DUT)
    traffic_control uut (
        .MR(MR), 
        .MY(MY), 
        .MG(MG), 
        .SR(SR), 
        .SY(SY), 
        .SG(SG), 
        .reset(reset), 
        .C(C), 
        .Clk(Clk)
    );

    initial begin
        C = 0;
        reset = 1;
        Clk = 0;
        #50; reset = 0; C = 1;
        #200; C = 0;
        #200; C = 1;
        #200; reset = 1;
        #50; reset = 0;
    end

    always begin
        #50 Clk = ~Clk;
    end
endmodule

