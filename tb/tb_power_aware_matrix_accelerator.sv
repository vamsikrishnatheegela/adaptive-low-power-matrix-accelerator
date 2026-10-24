`timescale 1ns/1ps
module tb_power_aware_matrix_accelerator;
    logic clk=0, reset_n=0, start=0;
    logic signed [7:0] a00=1,a01=2,a10=3,a11=4;
    logic signed [7:0] b00=5,b01=6,b10=7,b11=8;
    logic sleep_request=0, wake_request=0;
    logic [7:0] idle_count=0;
    logic [1:0] requested_operating_point=1;
    logic power_good=1, dvfs_ack=0;
    logic signed [16:0] c00,c01,c10,c11;
    logic busy,done,ready,power_domain_on,dvfs_request;
    logic [1:0] operating_point;
    logic [2:0] power_state_debug;
    integer errors=0;
    always #5 clk=~clk;

    power_aware_matrix_accelerator dut (.*);

    task automatic check_condition(input logic condition, input string message);
        if (!condition) begin
            $error("%s (power_state=%0d busy=%b ready=%b)", message,
                   power_state_debug,busy,ready);
            errors=errors+1;
        end
    endtask

    initial begin
        repeat (2) @(posedge clk);
        #1 reset_n=1;
        @(negedge clk);
        check_condition(ready,"should be ready after reset");
        start=1;
        @(negedge clk); start=0;
        check_condition(busy,"accepted operation should be busy");

        // A sleep request during a transaction must not power the domain off.
        // Check each cycle while busy so the one-cycle done pulse cannot be missed.
        sleep_request=1; idle_count=4;
        while (busy) begin
            @(negedge clk);
            check_condition(power_domain_on,"must remain powered during active transaction");
        end
        #1;
        check_condition(c00==19 && c01==22 && c10==43 && c11==50,
                        "integrated matrix result mismatch");
        @(negedge clk);
        check_condition(!power_domain_on,"should enter sleep after operation drains");
        check_condition(!ready,"must not accept work while asleep");
        sleep_request=0;

        wake_request=1;
        @(negedge clk); wake_request=0; power_good=0;
        check_condition(power_domain_on,"wake should request domain power-on");
        repeat (2) @(negedge clk);
        power_good=1;
        @(negedge clk);
        check_condition(dvfs_request,"wake must wait for operating-point acknowledgement");
        dvfs_ack=1;
        @(negedge clk); dvfs_ack=0;
        @(negedge clk);
        check_condition(ready,"should become ready after wake and DVFS acknowledgement");

        start=1;
        @(negedge clk); start=0;
        wait(done); #1;
        check_condition(c00==19 && c01==22 && c10==43 && c11==50,
                        "post-wake operation result mismatch");
        if (errors==0) begin
            $display("PASS: tb_power_aware_matrix_accelerator");
            $finish;
        end else $fatal(1,"FAIL: %0d errors",errors);
    end

    initial begin
        #2000;
        $fatal(1,"timeout in integrated power-aware testbench");
    end
endmodule
