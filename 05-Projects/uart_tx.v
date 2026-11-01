
module uart_tx(
    input clk,
    input rst,
    input tx_start,
    input [7:0] data_in,

    output reg tx,
    output reg busy
);

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            state <= IDLE;
            tx <= 1'b1;
            busy <= 1'b0;
            shift_reg <= 8'd0;
            bit_count <= 3'd0;
        end

        else
        begin
            case(state)

                IDLE:
                begin
                    tx <= 1'b1;
                    busy <= 1'b0;

                    if(tx_start)
                    begin
                        busy <= 1'b1;
                        shift_reg <= data_in;
                        bit_count <= 3'd0;
                        state <= START;
                    end
                end

                START:
                begin
                    tx <= 1'b0;
                    state <= DATA;
                end

                DATA:
                begin
                    tx <= shift_reg[0];
                    shift_reg <= shift_reg >> 1;

                    if(bit_count == 3'd7)
                        state <= STOP;
                    else
                        bit_count <= bit_count + 1;
                end

                STOP:
                begin
                    tx <= 1'b1;
                    busy <= 1'b0;
                    state <= IDLE;
                end

            endcase
        end
    end

endmodule
