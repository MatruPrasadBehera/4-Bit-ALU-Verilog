`timescale 1ns/1ps

module alu_4bit (
    input  [3:0] A,
    input  [3:0] B,
    input  [2:0] ALU_Sel,
    output reg [3:0] ALU_Out,
    output reg       CarryOut,
    output           Zero
);

always @(*) begin
    ALU_Out  = 4'b0000;
    CarryOut = 1'b0;

    case (ALU_Sel)
        3'b000: {CarryOut, ALU_Out} = A + B;          // ADD
        3'b001: {CarryOut, ALU_Out} = A - B;          // SUB
        3'b010: ALU_Out = A & B;                      // AND
        3'b011: ALU_Out = A | B;                      // OR
        3'b100: ALU_Out = A ^ B;                      // XOR
        3'b101: ALU_Out = ~A;                         // NOT A
        3'b110: {CarryOut, ALU_Out} = A + 4'b0001;   // INC A
        3'b111: {CarryOut, ALU_Out} = A - 4'b0001;   // DEC A
        default: begin
            ALU_Out  = 4'b0000;
            CarryOut = 1'b0;
        end
    endcase
end

assign Zero = (ALU_Out == 4'b0000);

endmodule
