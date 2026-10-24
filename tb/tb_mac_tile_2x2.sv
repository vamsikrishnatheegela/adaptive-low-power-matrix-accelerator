`timescale 1ns/1ps
module tb_mac_tile_2x2;
    logic signed [7:0] a00,a01,a10,a11,b00,b01,b10,b11;
    logic signed [16:0] c00,c01,c10,c11;
    integer errors=0;
    integer i;
    mac_tile_2x2 dut (.*);

    task automatic check_result(input integer e00,e01,e10,e11, input string label_text);
        #1;
        if (c00 !== e00 || c01 !== e01 || c10 !== e10 || c11 !== e11) begin
            $error("%s: got [%0d %0d; %0d %0d], expected [%0d %0d; %0d %0d]",
                   label_text,c00,c01,c10,c11,e00,e01,e10,e11);
            errors=errors+1;
        end
    endtask

    initial begin
        a00=1; a01=0; a10=0; a11=1;
        b00=-7; b01=12; b10=33; b11=-4;
        check_result(-7,12,33,-4,"identity");
        a00=-3; a01=5; a10=7; a11=-2;
        b00=4; b01=-6; b10=-8; b11=9;
        check_result(-52,63,44,-60,"signed products");
        a00=-128; a01=127; a10=127; a11=-128;
        b00=-128; b01=127; b10=127; b11=-128;
        check_result(32257,-32512,-32512,32257,"boundary values");
        for (i=0;i<100;i=i+1) begin
            a00=$random; a01=$random; a10=$random; a11=$random;
            b00=$random; b01=$random; b10=$random; b11=$random;
            check_result(
                $signed(a00)*$signed(b00)+$signed(a01)*$signed(b10),
                $signed(a00)*$signed(b01)+$signed(a01)*$signed(b11),
                $signed(a10)*$signed(b00)+$signed(a11)*$signed(b10),
                $signed(a10)*$signed(b01)+$signed(a11)*$signed(b11),
                "random vector");
        end
        if (errors==0) begin
            $display("PASS: tb_mac_tile_2x2 (103 vectors)");
            $finish;
        end else $fatal(1,"FAIL: %0d errors",errors);
    end
endmodule
