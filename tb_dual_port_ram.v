`timescale 1ns/1ps

module dual_port_ram_tb;
parameter DATA_WIDTH = 8;
parameter ADDR_WIDTH = 4;
parameter DEPTH = 16;
reg clk_a, we_a;
reg [ADDR_WIDTH-1:0] addr_a;
reg [DATA_WIDTH-1:0] din_a;
wire [DATA_WIDTH-1:0] dout_a;

reg clk_b, we_b;
reg [ADDR_WIDTH-1:0] addr_b;
reg [DATA_WIDTH-1:0] din_b;
wire [DATA_WIDTH-1:0] dout_b;

wire collision;

dual_port_ram #(DATA_WIDTH, ADDR_WIDTH, DEPTH) dut (
.clk_a(clk_a), .we_a(we_a), .addr_a(addr_a), .din_a(din_a), .dout_a(dout_a), .clk_b(clk_b), .we_b(we_b), .addr_b(addr_b), .din_b(din_b), .dout_b(dout_b), 
.collision(collision) 
);

initial clk_a=0;
initial clk_b=0;
always #5 clk_a=~clk_a;
always #5 clk_b=~clk_b;

initial begin
$dumpfile("dump.vcd");
$dumpvars(0, dual_port_ram_tb);
end

task port_a_write;
input [ADDR_WIDTH-1:0] addr;
input [DATA_WIDTH-1:0] data;
begin
@(posedge clk_a); #1;
we_a = 1'b1; addr_a = addr; din_a = data;
@(posedge clk_a); #1;
we_a = 1'b0;
$display("[A] WRITE addr=%0h data=0x%h", addr, data);
end

task port_b_write;
input [ADDR_WIDTH-1:0] addr;
input [DATA_WIDTH-1:0] data;
begin
@(posedge clk_b); #1;
we_b = 1'b1; addr_b = addr; din_b = data;
@(posedge clk_b); #1;
we_b = 1'b0;
$display("[B] WRITE addr=%0h data=0x%h", addr, data);
end
endtask

task port_a_read;
input [ADDR_WIDTH-1:0] addr;
begin
@(posedge clk_a); #1;
we_a = 1'b0; addr_a = addr;
@(posedge clk_a); #1;
$display("[A] READ addr=%0h dout=0x%h", addr, dout_a);
end
endtask

task port_b_read;
input [ADDR_WIDTH-1:0] addr;
begin
@(posedge clk_b); #1;
we_b = 1'b0; addr_b = addr;
@(posedge clk_b); #1;
$display("[B] READ addr=%0h dout=0x%h", addr, dout_b);
end
endtask

integer j;

initial begin

we_a=0; we_b=0;
addr_a=0; addr_b=0;
din_a=0; din_b=0;
repeat(2) @(posedge clk_a);

$display("\n--- TEST 1: Port A Write, Port B Read ---");
port_a_write(4'h0, 8'hAB);
port_b_read(4'h0);

$display("\n--- TEST 2: Port B Write, Port A Read ---");
port_b_write(4'h1, 8'h55);
port_a_read(4'h1);

$display("\n--- TEST 3: Simultaneous write, different addr ---");
@(posedge clk_a); #1;
we_a=1; addr_a=4'h2; din_a=8'h11;
we_b=1; addr_b=4'h3; din_b=8'h22;
@(posedge clk_a); #1;
we_a=0; we_b=0;
@(posedge clk_a); #1;
$display("collision=%b (expect 0)", collision);
port_a_read(4'h2);
port_b_read(4'h3);

$display("\n--- TEST 4: Same addr COLLISION ---");
@(posedge clk_a); #1;
we_a=1; addr_a=4'h5; din_a=8'hAA;
we_b=1; addr_b=4'h5; din_b=8'hBB;
@(posedge clk_a); #1;
$display("collision=%b (expect 1)", collision);
we_a=0; we_b=0;

$display("\n--- TEST 5: Read + Write same addr (COLLISION) ---");
@(posedge clk_a); #1;
we_a=0; addr_a=4'h5; 
we_b=1; addr_b=4'h5; din_b=8'hFF;
@(posedge clk_a); #1;
$display("collision=%b (expect 1)", collision);
we_b=0;

$display("\n--- TEST 6: Both read same addr (no collision) ---");
@(posedge clk_a); #1;
we_a=0; addr_a=4'h0;
we_b=0; addr_b=4'h0;
@(posedge clk_a); #1;
$display("collision=%b (expect 0)", collision);
$display("dout_a=0x%h dout_b=0x%h (both expect AB)", dout_a, dout_b);

$display("\n--- TEST 7: Fill all memory and verify ---");
for (j=0; j<DEPTH; j=j+1)
port_a_write(j[ADDR_WIDTH-1:0], j[DATA_WIDTH-1:0]);
for (j=0; j<DEPTH; j=j+1)
port_b_read(j[ADDR_WIDTH-1:0]);

#20;
$display("\n=== ALL TESTS DONE ===");
$finish;
end

initial begin
#10000;
$display("TIMEOUT");
$finish;
end

endmodule


















