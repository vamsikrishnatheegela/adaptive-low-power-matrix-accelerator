// SPDX-License-Identifier: MIT
`timescale 1ns/1ps
module mac_tile_2x2 (
    input logic signed [7:0] a00, a01, a10, a11,
    input logic signed [7:0] b00, b01, b10, b11,
    output logic signed [16:0] c00, c01, c10, c11
);
    logic signed [15:0] p00, p01, p02, p03;
    logic signed [15:0] p10, p11, p12, p13;
    always @* begin
        p00 = a00 * b00; p01 = a01 * b10;
        p02 = a00 * b01; p03 = a01 * b11;
        p10 = a10 * b00; p11 = a11 * b10;
        p12 = a10 * b01; p13 = a11 * b11;
        c00 = $signed({p00[15],p00}) + $signed({p01[15],p01});
        c01 = $signed({p02[15],p02}) + $signed({p03[15],p03});
        c10 = $signed({p10[15],p10}) + $signed({p11[15],p11});
        c11 = $signed({p12[15],p12}) + $signed({p13[15],p13});
    end
endmodule
