// SPDX-License-Identifier: MIT
// Control-plane model only; physical ICG, power switches, and DVFS hardware
// must be supplied by the target technology and implementation flow.
module adaptive_power_manager #(
    parameter int IDLE_COUNT_WIDTH = 8
) (
    input logic clk, reset_n,
    input logic workload_active, sleep_request, wake_request,
    input logic [IDLE_COUNT_WIDTH-1:0] idle_count,
    input logic [1:0] requested_operating_point, // 0=low, 1=nominal, 2=high
    input logic power_good, dvfs_ack,
    output logic compute_enable,       // enable intent; not a gated clock
    output logic power_domain_on,      // active-high power-switch request
    output logic dvfs_request,
    output logic [1:0] operating_point,
    output logic [2:0] state_debug
);
    localparam logic [2:0] ST_ACTIVE=3'd0, ST_DVFS_WAIT=3'd1,
                           ST_POWER_OFF=3'd2, ST_WAKE_WAIT=3'd3;
    logic [2:0] state, next_state;
    logic [1:0] target_operating_point;

    always_comb begin
        next_state = state;
        compute_enable = 1'b0;
        power_domain_on = 1'b1;
        dvfs_request = 1'b0;
        state_debug = state;
        case (state)
            ST_ACTIVE: begin
                compute_enable = workload_active;
                if (requested_operating_point != operating_point)
                    next_state = ST_DVFS_WAIT;
                else if (sleep_request && !workload_active && (idle_count != '0))
                    next_state = ST_POWER_OFF;
            end
            ST_DVFS_WAIT: begin
                dvfs_request = 1'b1;
                if (dvfs_ack) next_state = ST_ACTIVE;
            end
            ST_POWER_OFF: begin
                power_domain_on = 1'b0;
                if (wake_request) next_state = ST_WAKE_WAIT;
            end
            ST_WAKE_WAIT: begin
                if (power_good) next_state = ST_DVFS_WAIT;
            end
            default: next_state = ST_ACTIVE;
        endcase
    end

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= ST_ACTIVE;
            operating_point <= 2'd1;
            target_operating_point <= 2'd1;
        end else begin
            state <= next_state;
            if (state == ST_ACTIVE && requested_operating_point != operating_point)
                target_operating_point <= requested_operating_point;
            if (state == ST_DVFS_WAIT && dvfs_ack)
                operating_point <= target_operating_point;
            if (state == ST_WAKE_WAIT && power_good)
                target_operating_point <= requested_operating_point;
        end
    end
endmodule
