// SPDX-License-Identifier: MIT
`timescale 1ns/1ps
// Functional integration model: coordinates transaction admission with the
// power-manager FSM. This is not a physical clock/power-gating implementation.
module power_aware_matrix_accelerator #(
    parameter int IDLE_COUNT_WIDTH = 8
) (
    input logic clk, reset_n,
    input logic start,
    input logic signed [7:0] a00,a01,a10,a11,
    input logic signed [7:0] b00,b01,b10,b11,
    input logic sleep_request, wake_request,
    input logic [IDLE_COUNT_WIDTH-1:0] idle_count,
    input logic [1:0] requested_operating_point,
    input logic power_good, dvfs_ack,
    output logic signed [16:0] c00,c01,c10,c11,
    output logic busy, done, ready,
    output logic power_domain_on, dvfs_request,
    output logic [1:0] operating_point,
    output logic [2:0] power_state_debug
);
    logic compute_enable;
    logic accepted_start;
    logic manager_workload_active;

    // The manager sees a transaction as active from acceptance through the
    // wrapper's completion state. Requests are accepted only in ACTIVE state.
    assign ready = power_domain_on && !dvfs_request &&
                   (power_state_debug == 3'd0) && !busy;
    assign accepted_start = start && ready;
    assign manager_workload_active = busy;

    matrix_accelerator u_matrix_accelerator (
        .clk(clk), .reset_n(reset_n), .start(accepted_start),
        .a00(a00), .a01(a01), .a10(a10), .a11(a11),
        .b00(b00), .b01(b01), .b10(b10), .b11(b11),
        .c00(c00), .c01(c01), .c10(c10), .c11(c11),
        .busy(busy), .done(done)
    );

    adaptive_power_manager #(.IDLE_COUNT_WIDTH(IDLE_COUNT_WIDTH)) u_power_manager (
        .clk(clk), .reset_n(reset_n),
        .workload_active(manager_workload_active),
        .sleep_request(sleep_request), .wake_request(wake_request),
        .idle_count(idle_count),
        .requested_operating_point(requested_operating_point),
        .power_good(power_good), .dvfs_ack(dvfs_ack),
        .compute_enable(compute_enable),
        .power_domain_on(power_domain_on), .dvfs_request(dvfs_request),
        .operating_point(operating_point), .state_debug(power_state_debug)
    );
endmodule
