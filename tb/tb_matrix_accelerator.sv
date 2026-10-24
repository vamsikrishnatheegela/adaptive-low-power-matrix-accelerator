`timescale 1ns/1ps
module tb_matrix_accelerator;
    logic clk=0, reset_n=0, start=0;
    logic signed [7:0] a00,a01,a10,a11,b00,b01,b10,b11;
    logic signed [16:0] c00,c01,c10,c11;
    logic busy,done;
    integer errors=0;
    always #5 clk=~clk;

    matrix_accelerator dut (.*);

    task automatic check_condition(input logic condition, input string message);
        if (!condition) begin
            $error("%s",message);
            errors=errors+1;
        end
    endtask

    initial begin
        a00=1; a01=2; a10=3; a11=4;
        b00=5; b01=6; b10=7; b11=8;
        repeat(2) @(posedge clk);
        #1 reset_n=1;
        @(negedge clk); start=1;
        @(negedge clk); start=0;
        wait(done===1'b1);
        #1;
        check_condition(c00==19 && c01==22 && c10==43 && c11==50,
                        "matrix accelerator result mismatch");
        check_condition(busy,"busy should remain asserted with done");
        @(posedge clk); #1;
        check_condition(!done && !busy,"wrapper should return to idle after done pulse");
        if (errors==0) begin
            $display("PASS: tb_matrix_accelerator");
            $finish;
        end else $fatal(1,"FAIL: %0d errors",errors);
    end
endmodule
