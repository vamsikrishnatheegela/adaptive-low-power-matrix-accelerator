`timescale 1ns/1ps
module tb_adaptive_power_manager;
    logic clk=0, reset_n=0;
    logic workload_active=0, sleep_request=0, wake_request=0;
    logic [7:0] idle_count=0;
    logic [1:0] requested_operating_point=1;
    logic power_good=1, dvfs_ack=0;
    logic compute_enable,power_domain_on,dvfs_request;
    logic [1:0] operating_point;
    logic [2:0] state_debug;
    integer errors=0;
    always #5 clk=~clk;
    adaptive_power_manager dut (.*);

    task automatic tick; @(posedge clk); #1; endtask
    task automatic check_condition(input logic condition, input string message);
        if (!condition) begin
            $error("%s (state=%0d op=%0d)",message,state_debug,operating_point);
            errors=errors+1;
        end
    endtask

    initial begin
        repeat(2) tick();
        reset_n=1; tick();
        check_condition(power_domain_on && operating_point==1,"reset active nominal");
        workload_active=1; tick();
        check_condition(compute_enable,"active workload enables compute");
        requested_operating_point=2; tick();
        check_condition(!dvfs_request && compute_enable,
                        "operating-point change must defer while workload is active");
        workload_active=0; tick();
        check_condition(dvfs_request && !compute_enable,
                        "DVFS starts after workload drains");
        dvfs_ack=1; tick(); dvfs_ack=0;
        check_condition(operating_point==2,"ack updates operating point");
        workload_active=0; sleep_request=1; idle_count=4; tick();
        check_condition(!power_domain_on,"idle request powers domain down");
        wake_request=1; tick(); wake_request=0; power_good=0; tick();
        check_condition(power_domain_on,"wake requests power on");
        power_good=1; tick();
        check_condition(dvfs_request,"power-good waits for DVFS acknowledgement");
        dvfs_ack=1; tick(); dvfs_ack=0; sleep_request=0;
        check_condition(power_domain_on && !dvfs_request,"returns active after wake");
        if (errors==0) begin
            $display("PASS: tb_adaptive_power_manager");
            $finish;
        end else $fatal(1,"FAIL: %0d errors",errors);
    end
endmodule
