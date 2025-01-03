// FSM
`timescale 1ns / 1ps

 module fsm(
    output MR,
    output MY,
    output MG,
    output SR,
    output SY,
    output SG,
    output ST,
    input TS,
    input TL,
    input C,
    input reset,
    input Clk
);
    reg [6:1] state;
    reg internal_ST; // Mengganti nama register internal untuk menghindari konflik

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
            state = mainroadgreen;
            internal_ST = 1;
        end else begin
            internal_ST = 0;
            case (state)
                mainroadgreen:
                    if (TL & C) begin
                        state = mainroadyellow;
                        internal_ST = 1;
                    end
                mainroadyellow:
                    if (TS) begin
                        state = sideroadgreen;
                        internal_ST = 1;
                    end
                sideroadgreen:
                    if (TL | !C) begin
                        state = sideroadyellow;
                        internal_ST = 1;
                    end
                sideroadyellow:
                    if (TS) begin
                        state = mainroadgreen;
                        internal_ST = 1;
                    end
            endcase
        end
    end
endmodule

