module uart_tx #(

    parameter CLOCK_FREQ = 50000000,
    parameter BAUD_RATE  = 115200

)(

    input  wire       clk,
    input  wire       rst,
    input  wire       tx_start,
    input  wire [7:0] data_in,

    output reg        tx,
    output reg        busy,
    output reg        tx_done

);

    //=====================================
    // Baud Generator Instance
    //=====================================

    wire baud_tick;

    baud_gen #(
        .CLOCK_FREQ(CLOCK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) BAUD_GEN (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick)
    );

    //=====================================
    // State Encoding
    //=====================================

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    //=====================================
    // Internal Registers
    //=====================================

    reg [1:0] state;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    //=====================================
    // UART Transmitter FSM
    //=====================================

    always @(posedge clk or posedge rst)
    begin

        if (rst)
        begin
            state     <= IDLE;
            tx        <= 1'b1;
            busy      <= 1'b0;
            tx_done   <= 1'b0;
            shift_reg <= 8'd0;
            bit_count <= 3'd0;
        end
        else
        begin

            // Default
            tx_done <= 1'b0;

            case(state)

                //---------------------------------
                // IDLE
                //---------------------------------

                IDLE:
                begin
                    tx   <= 1'b1;
                    busy <= 1'b0;

                    if(tx_start)
                    begin
                        busy      <= 1'b1;
                        shift_reg <= data_in;
                        bit_count <= 3'd0;
                        state     <= START;
                    end
                end

                //---------------------------------
                // START BIT
                //---------------------------------

                START:
                begin
                    tx <= 1'b0;

                    if(baud_tick)
                        state <= DATA;
                end

                //---------------------------------
                // DATA BITS
                //---------------------------------

                DATA:
                begin
                    tx <= shift_reg[0];

                    if(baud_tick)
                    begin
                        shift_reg <= shift_reg >> 1;

                        if(bit_count == 3'd7)
                            state <= STOP;
                        else
                            bit_count <= bit_count + 1'b1;
                    end
                end

                //---------------------------------
                // STOP BIT
                //---------------------------------

                STOP:
                begin
                    tx <= 1'b1;

                    if(baud_tick)
                    begin
                        busy    <= 1'b0;
                        tx_done <= 1'b1;
                        state   <= IDLE;
                    end
                end

                //---------------------------------
                // DEFAULT
                //---------------------------------

                default:
                begin
                    state <= IDLE;
                    tx    <= 1'b1;
                    busy  <= 1'b0;
                end

            endcase

        end

    end

endmodule