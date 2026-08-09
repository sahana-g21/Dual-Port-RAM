`timescale 1ns/1ps

module dual_port_ram #(
parameter DATA_WIDTH = 8,
parameter ADDR_WIDTH = 4,
parameter DEPTH = 16
)(
input wire clk_a, we_a,
input wire [ADDR_WIDTH-1:0] addr_a,
input wire [DATA_WIDTH-1:0] din_a,
output reg [DATA_WIDTH-1:0] dout_a,

input wire clk_b, we_b,
input wire [ADDR_WIDTH-1:0] addr_b,
input wire [DATA_WIDTH-1:0] din_b,
output reg [DATA_WIDTH-1:0] dout_b,

output reg collision);

reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

//PORT A
always @(posedge clk_a) begin
if (we_a) begin
mem[addr_a] <= din_a;
dout_a <= din_a;
end
else begin
dout_a <= mem[addr_a];
end
end

//PORT B
always @(posedge clk_b) begin
if (we_b) begin
mem[addr_b] <= din_b;
dout_b <= din_b;
end
else begin
dout_b <= mem[addr_b];
end
end

//COLLISION DETECTION
always @(posedge clk_a) begin
if ((addr_a == addr_b) && (we_a || we_b))
collision <= 1'b1;
else
collision <= 1'b0;
end
endmodule































