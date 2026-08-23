`timescale 1ns/1ps

module alu_4bit_tb;

reg [3:0] A;
reg [3:0] B;
reg [2:0] ALU_Sel;

wire [3:0] ALU_Out;
wire       CarryOut;
wire       Zero;

integer pass_count;
integer fail_count;

alu_4bit DUT (
    .A(A),
    .B(B),
    .ALU_Sel(ALU_Sel),
    .ALU_Out(ALU_Out),
    .CarryOut(CarryOut),
    .Zero(Zero)
);

task check_result;
    input [3:0] expected;
    input        expected_carry;
    input        expected_zero;

    begin
        #1;
        if ((ALU_Out == expected) &&
            (CarryOut == expected_carry) &&
            (Zero == expected_zero)) begin

            $display("PASS | A=%b B=%b SEL=%b | OUT=%b CARRY=%b ZERO=%b",
                     A, B, ALU_Sel, ALU_Out, CarryOut, Zero);
            pass_count = pass_count + 1;

        end else begin

            $display("FAIL | A=%b B=%b SEL=%b | OUT=%b CARRY=%b ZERO=%b",
                     A, B, ALU_Sel, ALU_Out, CarryOut, Zero);
            $display("      Expected: OUT=%b CARRY=%b ZERO=%b",
                     expected, expected_carry, expected_zero);
            fail_count = fail_count + 1;

        end
    end
endtask

initial begin

    $dumpfile("alu_sim.vcd");
    $dumpvars(0, alu_4bit_tb);

    pass_count = 0;
    fail_count = 0;

    $display("==============================================");
    $display("        4-BIT ALU FUNCTIONAL TEST");
    $display("==============================================");

    // 1. Addition: 5 + 3 = 8
    A = 4'b0101; B = 4'b0011; ALU_Sel = 3'b000;
    check_result(4'b1000, 1'b0, 1'b0);

    // 2. Subtraction: 8 - 3 = 5
    A = 4'b1000; B = 4'b0011; ALU_Sel = 3'b001;
    check_result(4'b0101, 1'b0, 1'b0);

    // 3. AND: 1100 & 1010 = 1000
    A = 4'b1100; B = 4'b1010; ALU_Sel = 3'b010;
    check_result(4'b1000, 1'b0, 1'b0);

    // 4. OR: 1100 | 1010 = 1110
    A = 4'b1100; B = 4'b1010; ALU_Sel = 3'b011;
    check_result(4'b1110, 1'b0, 1'b0);

    // 5. XOR: 1100 ^ 1010 = 0110
    A = 4'b1100; B = 4'b1010; ALU_Sel = 3'b100;
    check_result(4'b0110, 1'b0, 1'b0);

    // 6. NOT: ~1010 = 0101
    A = 4'b1010; B = 4'b0000; ALU_Sel = 3'b101;
    check_result(4'b0101, 1'b0, 1'b0);

    // 7. Increment: 0101 + 1 = 0110
    A = 4'b0101; B = 4'b0000; ALU_Sel = 3'b110;
    check_result(4'b0110, 1'b0, 1'b0);

    // 8. Decrement: 0101 - 1 = 0100
    A = 4'b0101; B = 4'b0000; ALU_Sel = 3'b111;
    check_result(4'b0100, 1'b0, 1'b0);

    // 9. Carry test: 1111 + 0001 = 0000
    A = 4'b1111; B = 4'b0001; ALU_Sel = 3'b000;
    check_result(4'b0000, 1'b1, 1'b1);

    // 10. Zero test: 0101 - 0101 = 0000
    A = 4'b0101; B = 4'b0101; ALU_Sel = 3'b001;
    check_result(4'b0000, 1'b0, 1'b1);

    // 11. Increment overflow/carry: 1111 + 1 = 0000
    A = 4'b1111; B = 4'b0000; ALU_Sel = 3'b110;
    check_result(4'b0000, 1'b1, 1'b1);

    // 12. Decrement zero: 0000 - 1 = 1111
    A = 4'b0000; B = 4'b0000; ALU_Sel = 3'b111;
    check_result(4'b1111, 1'b1, 1'b0);

    $display("==============================================");
    $display("        TEST SUMMARY");
    $display("==============================================");
    $display("PASS COUNT = %0d", pass_count);
    $display("FAIL COUNT = %0d", fail_count);

    if (fail_count == 0)
        $display("RESULT = ALL TESTS PASSED");
    else
        $display("RESULT = SOME TESTS FAILED");

    $display("==============================================");

    $finish;
end

endmodule
