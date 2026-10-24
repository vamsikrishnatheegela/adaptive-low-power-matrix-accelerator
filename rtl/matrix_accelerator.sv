// Sequential wrapper around the combinational 2x2 tile.
// One input matrix pair is accepted per transaction; outputs are held until next completion.
module matrix_accelerator (
    input logic clk, reset_n,
    input logic start,
    input logic signed [7:0] a00,a01,a10,a11,
    input logic signed [7:0] b00,b01,b10,b11,
    output logic signed [16:0] c00,c01,c10,c11,
    output logic busy, done
);
    localparam logic [1:0] ST_IDLE=2'd0, ST_COMPUTE=2'd1, ST_DONE=2'd2;
    logic [1:0] state;
    logic signed [7:0] ar00,ar01,ar10,ar11,br00,br01,br10,br11;
    logic signed [16:0] tile_c00,tile_c01,tile_c10,tile_c11;

    mac_tile_2x2 tile (
        .a00(ar00), .a01(ar01), .a10(ar10), .a11(ar11),
        .b00(br00), .b01(br01), .b10(br10), .b11(br11),
        .c00(tile_c00), .c01(tile_c01), .c10(tile_c10), .c11(tile_c11)
    );

    always_comb begin
        busy = (state != ST_IDLE);
        done = (state == ST_DONE);
    end

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= ST_IDLE;
            ar00 <= '0; ar01 <= '0; ar10 <= '0; ar11 <= '0;
            br00 <= '0; br01 <= '0; br10 <= '0; br11 <= '0;
            c00 <= '0; c01 <= '0; c10 <= '0; c11 <= '0;
        end else begin
            case (state)
                ST_IDLE: if (start) begin
                    ar00 <= a00; ar01 <= a01; ar10 <= a10; ar11 <= a11;
                    br00 <= b00; br01 <= b01; br10 <= b10; br11 <= b11;
                    state <= ST_COMPUTE;
                end
                ST_COMPUTE: begin
                    c00 <= tile_c00; c01 <= tile_c01;
                    c10 <= tile_c10; c11 <= tile_c11;
                    state <= ST_DONE;
                end
                ST_DONE: state <= ST_IDLE;
                default: state <= ST_IDLE;
            endcase
        end
    end
endmodule
