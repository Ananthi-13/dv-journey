`timescale 1ns/1ps

module uart_tx_tb;

reg clk;
reg rst;
reg tx_start;
reg [7:0] data_in;

wire tx;
wire busy;

uart_tx DUT(
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .data_in(data_in),
    .tx(tx),
    .busy(busy)
);

initial
begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial
begin

    $dumpfile("dump.vcd");
    $dumpvars(0, uart_tx_tb);

    rst = 1;
    tx_start = 0;
    data_in = 8'hA5;

    #20;
    rst = 0;

    #20;
    tx_start = 1;

    #10;
    tx_start = 0;

    #200;

    data_in = 8'h3C;

    #20;
    tx_start = 1;

    #10;
    tx_start = 0;

    #200;

    $finish;

end

endmodule
