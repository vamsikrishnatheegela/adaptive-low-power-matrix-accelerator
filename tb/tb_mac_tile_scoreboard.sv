`timescale 1ns/1ps
module tb_mac_tile_scoreboard;
    logic signed [7:0] a00,a01,a10,a11,b00,b01,b10,b11;
    logic signed [16:0] c00,c01,c10,c11;
    integer errors = 0;
    integer i;
    integer seed = 32'h51A7C0DE;
    integer e00,e01,e10,e11;

    mac_tile_2x2 dut (.*);

    // Independent reference helper: widen signed operands to integer before
    // multiplication, then sum in 32-bit signed arithmetic.
    function automatic integer dot2(
        input logic signed [7:0] x0, x1,
        input logic signed [7:0] y0, y1
    );
        integer ix0, ix1, iy0, iy1;
        begin
            ix0 = x0; ix1 = x1; iy0 = y0; iy1 = y1;
            dot2 = (ix0 * iy0) + (ix1 * iy1);
        end
    endfunction

    task automatic check_vector(input integer vector_id);
        begin
            e00 = dot2(a00,a01,b00,b10);
            e01 = dot2(a00,a01,b01,b11);
            e10 = dot2(a10,a11,b00,b10);
            e11 = dot2(a10,a11,b01,b11);
            #1;
            if (c00 !== e00 || c01 !== e01 || c10 !== e10 || c11 !== e11) begin
                $error("vector %0d mismatch: got [%0d %0d; %0d %0d], expected [%0d %0d; %0d %0d]",
                       vector_id,c00,c01,c10,c11,e00,e01,e10,e11);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        // Directed extremes and signedness combinations.
        a00=-128; a01=-128; a10=127; a11=127;
        b00=-128; b01=127; b10=127; b11=-128;
        check_vector(0);

        a00=127; a01=-128; a10=-128; a11=127;
        b00=127; b01=-128; b10=-128; b11=127;
        check_vector(1);

        // Reproducible pseudo-random regression.
        for (i=0; i<500; i=i+1) begin
            a00=$random(seed); a01=$random(seed);
            a10=$random(seed); a11=$random(seed);
            b00=$random(seed); b01=$random(seed);
            b10=$random(seed); b11=$random(seed);
            check_vector(i+2);
        end

        if (errors == 0) begin
            $display("PASS: tb_mac_tile_scoreboard (502 vectors, seed=0x51A7C0DE)");
            $finish;
        end else begin
            $fatal(1,"FAIL: tb_mac_tile_scoreboard had %0d errors",errors);
        end
    end
endmodule
