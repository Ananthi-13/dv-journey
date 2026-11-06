`timescale 1ns/1ps

module uart_tx_tb;

    reg clk;
    reg rst;
    reg tx_start;
    reg [7:0] data_in;

    wire tx;
    wire busy;
    wire tx_done;

    //=====================================
    // Instantiate UART Transmitter
    //=====================================

    uart_tx #(
        .CLOCK_FREQ(50000000),
        .BAUD_RATE(115200)
    ) DUT (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .data_in(data_in),
        .tx(tx),
        .busy(busy),
        .tx_done(tx_done)
    );

    //=====================================
    // Clock Generation (50 MHz)
    //=====================================

    initial
    begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    //=====================================
    // Test Sequence
    //=====================================

    initial
    begin

        

        rst      = 1;
        tx_start = 0;
        data_in  = 8'h00;

        #100;
        rst = 0;

        //---------------------------------
        // Test 1 : A5
        //---------------------------------

        @(posedge clk);
        data_in  = 8'hA5;
        tx_start = 1;

        @(posedge clk);
        tx_start = 0;

        wait(tx_done);

        #5000;

        //---------------------------------
        // Test 2 : 3C
        //---------------------------------

        @(posedge clk);
        data_in  = 8'h3C;
        tx_start = 1;

        @(posedge clk);
        tx_start = 0;

        wait(tx_done);

        #5000;

        //---------------------------------
        // Test 3 : FF
        //---------------------------------

        @(posedge clk);
        data_in  = 8'hFF;
        tx_start = 1;

        @(posedge clk);
        tx_start = 0;

        wait(tx_done);

        #5000;

        //---------------------------------
        // Test 4 : 00
        //---------------------------------

        @(posedge clk);
        data_in  = 8'h00;
        tx_start = 1;

        @(posedge clk);
        tx_start = 0;

        wait(tx_done);

        #5000;

        $finish;

    end

endmodule